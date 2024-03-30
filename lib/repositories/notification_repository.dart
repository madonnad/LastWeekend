import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';
import 'package:shared_photo/services/notification_service.dart';

class NotificationRepository {
  RealtimeRepository realtimeRepository;
  User user;
  Map<String, Notification> globalNotifications = <String, Notification>{};

  NotificationRepository(
      {required this.realtimeRepository, required this.user}) {
    initializeNotifications();
    realtimeRepository.notificationStream.listen((event) {
      switch (event.runtimeType) {
        case AlbumInviteNotification:
          AlbumInviteNotification notification =
              event as AlbumInviteNotification;
          globalNotifications.putIfAbsent(
              notification.notificationID, () => notification);

        case FriendRequestNotification:
          FriendRequestNotification notification =
              event as FriendRequestNotification;

          globalNotifications.putIfAbsent(
              notification.notificationID, () => notification);
        case GenericNotification:
          GenericNotification notification = event as GenericNotification;

          globalNotifications.putIfAbsent(
              notification.notificationID, () => notification);
      }
    });
  }

  Future<void> initializeNotifications() async {
    List<Notification> allNotifications =
        await NotificationService().getNotifications(user.token);

    for (Notification notification in allNotifications) {
      globalNotifications.putIfAbsent(
          notification.notificationID, () => notification);
    }
  }

  List<AlbumInviteNotification> get albumInviteNotifications {
    return globalNotifications.values
        .whereType<AlbumInviteNotification>()
        .toList();
  }

  List<FriendRequestNotification> get friendRequestNotifications {
    return globalNotifications.values
        .whereType<FriendRequestNotification>()
        .toList();
  }
}
