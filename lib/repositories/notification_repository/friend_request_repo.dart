part of 'notification_repository.dart';

extension FriendRequestRepo on NotificationRepository {
  void _friendRequestHandler(FriendRequestNotification request) {
    switch (request.status) {
      case RequestStatus.pending:
        friendRequestMap.putIfAbsent(request.notificationID, () => request);

        _notificationController.add((StreamOperation.add, request));
      case RequestStatus.accepted:
        friendRequestMap[request.notificationID] = request;
        _notificationController.add((StreamOperation.update, request));

      case RequestStatus.denied:
    }
  }

  Future<bool> acceptFriendRequest(String requestID, String senderID) async {
    bool success = await RequestService.acceptFriendRequest(
      user.token,
      senderID,
      requestID,
    );

    if (success) {
      // Update Source of Truth
      friendRequestMap.update(
          requestID, (value) => value.copyWith(status: RequestStatus.accepted));
      // Notify Listeners
      _notificationController
          .add((StreamOperation.update, friendRequestMap[requestID]!));
      return true;
    }
    return false;
  }

  Future<bool> denyFriendRequest(String requestID) async {
    bool success =
        await RequestService.deleteFriendRequest(user.token, requestID);

    if (success) {
      // Update Source of Truth
      FriendRequestNotification request =
          friendRequestMap[requestID]!.copyWith(status: RequestStatus.denied);

      friendRequestMap.removeWhere((key, value) => key == requestID);
      // Notify Listeners
      _notificationController.add((StreamOperation.delete, request));
      return true;
    }
    return false;
  }

  Future<bool> markFriendRequestSeen(String requestID) async {
    bool success =
        await RequestService.markFriendRequestAsSeen(user.token, requestID);

    if (success) {
      // Update Source of Truth
      FriendRequestNotification request =
          friendRequestMap[requestID]!.copyWith(notificationSeen: true);

      // Notify Listeners
      _notificationController.add((StreamOperation.update, request));
      return true;
    }
    return false;
  }

  void removeFriendRequestAccepted(
      bool canDelete, String notificationID) async {
    if (canDelete) {
      bool success =
          await RequestService.deleteFriendRequest(user.token, notificationID);
      if (!success) return;
    }

    FriendRequestNotification request = friendRequestMap[notificationID]!;
    _notificationController.add((StreamOperation.delete, request));
    friendRequestMap.remove(notificationID);
  }
}
