import 'dart:async';

import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';
import 'package:shared_photo/services/notification_service.dart';

class NotificationRepository {
  RealtimeRepository realtimeRepository;
  User user;
  Map<String, Notification> globalNotifications = <String, Notification>{};

  final _notificationController = StreamController<Notification>();
  Stream<Notification> get notificationStream => _notificationController.stream;

  NotificationRepository(
      {required this.realtimeRepository, required this.user}) {
    initializeNotifications();
    realtimeRepository.realtimeNotificationStream.listen((event) {
      switch (event.runtimeType) {
        case AlbumInviteNotification:
          AlbumInviteNotification notification =
              event as AlbumInviteNotification;

        case FriendRequestNotification:
          FriendRequestNotification notification =
              event as FriendRequestNotification;

          globalNotifications.putIfAbsent(
              notification.notificationID, () => notification);

          _notificationController.add(notification);
        case GenericNotification:
          GenericNotification notification = event as GenericNotification;

          globalNotifications.putIfAbsent(
              notification.notificationID, () => notification);

          _notificationController.add(notification);
      }
    });
  }

  void notificationTypeHandler(Notification notification) {
    switch (notification.runtimeType) {
      case FriendRequestNotification:
        friendRequestHandler(notification as FriendRequestNotification);
    }
  }

  void friendRequestHandler(FriendRequestNotification request) {
    switch (request.status) {
      case FriendRequestStatus.pending:
        globalNotifications.putIfAbsent(request.notificationID, () => request);

        _notificationController.add(request);
      case FriendRequestStatus.accepted:
        globalNotifications
            .removeWhere((key, value) => key == request.notificationID);

        
      case FriendRequestStatus.decline:
    }
  }

  Future<void> initializeNotifications() async {
    List<Notification> allNotifications =
        await NotificationService().getNotifications(user.token);

    for (Notification notification in allNotifications) {
      globalNotifications.putIfAbsent(
          notification.notificationID, () => notification);
    }
  }
}
