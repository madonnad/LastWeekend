part of 'notification_repository.dart';

extension AlbumInviteRepo on NotificationRepository {
  Future<bool> acceptAlbumRequest(String requestID) async {
    bool success =
        await RequestService.acceptAlbumInvite(user.token, requestID);

    if (success) {
      // Update Source of Truth
      albumInviteMap.update(
          requestID, (value) => value.copyWith(status: RequestStatus.accepted));
      // Notify Listeners Locally
      _notificationController
          .add((StreamOperation.update, albumInviteMap[requestID]!));
      return true;
    }
    return false;
  }
}
