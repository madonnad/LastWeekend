part of 'notification_repository.dart';

extension AllNotiRepo on NotificationRepository {
  void _engagementHandler(EngagementNotification notification) {
    if (user.id != notification.receiverID) return;
    if (notification.operation == EngageOperation.remove) return;

    late ConsolidatedNotification consolNoti;

    if (allNotificationMap[notification.mapKey] != null) {
      consolNoti =
          allNotificationMap[notification.mapKey] as ConsolidatedNotification;

      DateTime localNotiDate = consolNoti.latestDate.toLocal();
      DateTime now = DateTime.now();

      DateTime notiSimpleDate =
          DateTime(localNotiDate.year, localNotiDate.month, localNotiDate.day);
      DateTime today = DateTime(now.year, now.month, now.day);

      bool receivedToday = today.isAtSameMomentAs(notiSimpleDate);

      if (receivedToday) {
        Map<String, EngagementNotification> consolNotiMap =
            Map.from(consolNoti.notificationMap);

        DateTime latestDate = consolNoti.latestDate;

        if (latestDate.isBefore(notification.receivedDateTime)) {
          latestDate = notification.receivedDateTime;
        }

        consolNotiMap.putIfAbsent(
          notification.notificationID,
          () => notification,
        );

        consolNoti = consolNoti.copyWith(
          receivedDateTime: latestDate,
          latestDate: latestDate,
          notificationMap: consolNotiMap,
          notificationSeen: notification.notificationSeen,
        );

        allNotificationMap[notification.mapKey] = consolNoti;
        _notificationController.add((StreamOperation.add, consolNoti));
        return;
      }
    }
    Map<String, EngagementNotification> consolNotiMap = {};
    consolNotiMap[notification.notificationID] = notification;

    consolNoti = ConsolidatedNotification(
      notificationID: notification.notificationID,
      receivedDateTime: notification.receivedDateTime,
      notificationMediaID: notification.notificationMediaID,
      notificationSeen: notification.notificationSeen,
      notifierID: notification.notifierID,
      notifierFirst: notification.notifierFirst,
      notifierLast: notification.notifierLast,
      notificationMap: consolNotiMap,
      latestDate: notification.receivedDateTime,
    );

    allNotificationMap.putIfAbsent(notification.mapKey, () => consolNoti);
    _notificationController.add((StreamOperation.add, consolNoti));
    return;
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
