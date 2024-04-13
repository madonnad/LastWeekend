part of 'notification_repository.dart';

extension AllNotiRepo on NotificationRepository {
  Future<bool> markNotificationSeen(String notificationID) async {
    // bool success = await NotificationService.markNotificationSeen(
    //     user.token, notificationID);

    if (true) {
      // Update Source of Truth
      Notification notification =
          allNotificationMap[notificationID]!.copyWith(notificationSeen: true);
      // Notify Listeners
      _notificationController.add((StreamOperation.update, notification));
      return true;
    }
    //return false;
  }
}
