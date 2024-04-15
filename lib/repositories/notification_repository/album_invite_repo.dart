part of 'notification_repository.dart';

extension AlbumInviteRepo on NotificationRepository {
  void _albumInviteHandler(AlbumInviteNotification invite) {
    switch (invite.status) {
      case RequestStatus.pending:
        if (invite.guestID == user.id) {
          albumInviteMap.putIfAbsent(invite.notificationID, () => invite);
        }
        _notificationController.add((StreamOperation.add, invite));
      case RequestStatus.accepted:
        if (invite.albumOwner == user.id) {
          allNotificationMap.putIfAbsent(invite.notificationID, () => invite);
        }
        // Add album to album repo (update dash) & update notification map for
        // guest that accepted.
        _notificationController.add((StreamOperation.update, invite));
      case RequestStatus.denied:
        // Communicates to the notification cubit to remove
        // Also goes to the data repo to update the album if present
        _notificationController.add((StreamOperation.update, invite));
    }
  }

  Future<bool> acceptAlbumInvite(String requestID) async {
    bool success =
        await RequestService.acceptAlbumInvite(user.token, requestID);

    if (success) {
      // Update Source of Truth
      albumInviteMap.update(
          requestID, (value) => value.copyWith(status: RequestStatus.accepted));
      // Notify Listeners Locally - This will add album to data repo
      _notificationController
          .add((StreamOperation.update, albumInviteMap[requestID]!));
      return true;
    }
    return false;
  }

  Future<bool> denyAlbumInvite(String requestID) async {
    bool success = await RequestService.denyAlbumInvite(user.token, requestID);
    if (success) {
      // Update Source of Truth
      AlbumInviteNotification request =
          albumInviteMap[requestID]!.copyWith(status: RequestStatus.denied);

      albumInviteMap.removeWhere((key, value) => key == requestID);
      // Notify Listeners Locally
      _notificationController.add((StreamOperation.delete, request));
      return true;
    }
    return false;
  }
}
