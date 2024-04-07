part of 'notification_repository.dart';

extension AllNotiRepo on NotificationRepository {
  void _allNotiHandler(Notification notification) {
    allNotificationMap.putIfAbsent(
        notification.notificationID, () => notification);

    _notificationController.add((StreamOperation.add, notification));
  }

  Future<bool> markNotificationSeen(String notificationID) async {
    print("hello");
    bool success = await NotificationService.markNotificationSeen(
        user.token, notificationID);

    if (success) {
      // Update Source of Truth
      Notification notification =
          allNotificationMap[notificationID]!.copyWith(notificationSeen: true);
      // Notify Listeners
      _notificationController.add((StreamOperation.update, notification));
      return true;
    }
    return false;
  }
}
