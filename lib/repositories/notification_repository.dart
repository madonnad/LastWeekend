import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';

class NotificationRepository {
  RealtimeRepository realtimeRepository;
  Map<String, Notification> globalNotifications = <String, Notification>{};

  NotificationRepository({required this.realtimeRepository}) {
    realtimeRepository.notificationStream.listen((event) {
      switch (event.runtimeType) {
        case AlbumInviteNotification:
          AlbumInviteNotification notification =
              event as AlbumInviteNotification;
          globalNotifications[notification.notificationID] = notification;
        case FriendRequestNotification:
          FriendRequestNotification notification =
              event as FriendRequestNotification;
          globalNotifications[notification.notificationID] = notification;
        case GenericNotification:
          GenericNotification notification = event as GenericNotification;
          globalNotifications[notification.notificationID] = notification;
      }
    });
  }

  List<AlbumInviteNotification> get albumInviteNotifications {
    return globalNotifications.values
        .whereType<AlbumInviteNotification>()
        .toList();
  }
}
