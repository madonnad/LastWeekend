part of 'notification_repository.dart';

extension AllNotiRepo on NotificationRepository {
  void _allNotiHandler(Notification notification) {
    allNotificationMap.putIfAbsent(
        notification.notificationID, () => notification);
    
     _notificationController.add((StreamOperation.add, notification));
  }
}
