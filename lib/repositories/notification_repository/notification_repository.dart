import 'dart:async';

import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';
import 'package:shared_photo/services/notification_service.dart';
import 'package:shared_photo/services/request_service.dart';

part 'friend_request_repo.dart';
part 'album_invite_repo.dart';
part 'all_noti_repo.dart';

class NotificationRepository {
  //Imports
  RealtimeRepository realtimeRepository;
  User user;

  //Local Variable Store
  Map<String, FriendRequestNotification> friendRequestMap =
      <String, FriendRequestNotification>{};
  Map<String, AlbumInviteNotification> albumInviteMap =
      <String, AlbumInviteNotification>{};
  Map<String, Notification> allNotificationMap = <String, Notification>{};

  final _notificationController =
      StreamController<(StreamOperation, Notification)>.broadcast();
  Stream<(StreamOperation, Notification)> get notificationStream =>
      _notificationController.stream;

  NotificationRepository(
      {required this.realtimeRepository, required this.user}) {
    // Initialize Notifications from DB
    _initializeNotifications();

    //Listen to Realtime Notification Stream
    realtimeRepository.realtimeNotificationStream.listen((event) {
      _notificationTypeHandler(event);
    });
  }

  void _notificationTypeHandler(Notification notification) {
    switch (notification.runtimeType) {
      case FriendRequestNotification:
        _friendRequestHandler(notification as FriendRequestNotification);
      case AlbumInviteNotification:
        _albumInviteHandler(notification as AlbumInviteNotification);
      case EngagementNotification:
        _engagementHandler(notification as EngagementNotification);
      case CommentNotification:
        _commentHandler(notification as CommentNotification);
    }
  }

  Future<void> _initializeNotifications() async {
    List<Notification> allNotifications =
        await NotificationService().getNotifications(user.token);

    for (Notification notification in allNotifications) {
      switch (notification.runtimeType) {
        case FriendRequestNotification:
          friendRequestMap.putIfAbsent(notification.notificationID,
              () => notification as FriendRequestNotification);
          _notificationController.add((StreamOperation.add, notification));
        case AlbumInviteNotification:
          AlbumInviteNotification noti =
              notification as AlbumInviteNotification;
          switch (noti.status) {
            case RequestStatus.pending:
              albumInviteMap.putIfAbsent(noti.notificationID, () => noti);
              _notificationController.add((StreamOperation.add, noti));
            case RequestStatus.accepted:
              if (noti.guestID == user.id) {
                albumInviteMap.putIfAbsent(noti.notificationID, () => noti);
                _notificationController.add((StreamOperation.add, noti));
              }
              if (noti.albumOwner == user.id) {
                allNotificationMap.putIfAbsent(noti.notificationID, () => noti);
                _notificationController.add((StreamOperation.add, noti));
              }
            case RequestStatus.denied:
              if (noti.guestID == user.id) {
                albumInviteMap
                    .removeWhere((key, value) => key == noti.notificationID);
              }
              _notificationController.add((StreamOperation.delete, noti));
          }
        case EngagementNotification:
          EngagementNotification noti = notification as EngagementNotification;
          _engagementHandler(noti);
        case CommentNotification:
          _commentHandler(notification as CommentNotification);
      }
    }
  }
}
