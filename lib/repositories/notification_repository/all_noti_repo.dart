part of 'notification_repository.dart';

extension AllNotiRepo on NotificationRepository {
  void _engagementHandler(EngagementNotification notification) {
    if (user.id != notification.receiverID) return;
    if (notification.operation == EngageOperation.remove) return;

    switch (notification.notificationType) {
      case EngageType.liked:
      case EngageType.upvoted:
        allNotificationMap[notification.notificationID] = notification;
        _notificationController.add((StreamOperation.add, notification)); 
    }
  }

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
