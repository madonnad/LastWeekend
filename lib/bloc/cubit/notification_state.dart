part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final int currentIndex;
  final Map<String, FriendRequestNotification> friendRequestMap;
  final Map<String, AlbumInviteNotification> albumInviteMap;
  final Map<String, Notification> allNotificationMap;
  final String exception;
  final bool unseenFriendRequests;
  final bool unseenAlbumInvites;
  final bool unseenGenericNoti;

  const NotificationState({
    this.currentIndex = 0,
    this.friendRequestMap = const {},
    this.albumInviteMap = const {},
    this.allNotificationMap = const {},
    this.exception = '',
    this.unseenFriendRequests = false,
    this.unseenAlbumInvites = false,
    this.unseenGenericNoti = false,
  });

  NotificationState copyWith({
    int? currentIndex,
    Map<String, FriendRequestNotification>? friendRequestMap,
    Map<String, AlbumInviteNotification>? albumInviteMap,
    Map<String, Notification>? allNotificationMap,
    String? exception,
    bool? unseenFriendRequests,
    bool? unseenAlbumInvites,
    bool? unseenGenericNoti,
  }) {
    return NotificationState(
      currentIndex: currentIndex ?? this.currentIndex,
      friendRequestMap: friendRequestMap ?? this.friendRequestMap,
      albumInviteMap: albumInviteMap ?? this.albumInviteMap,
      allNotificationMap: allNotificationMap ?? this.allNotificationMap,
      exception: exception ?? this.exception,
      unseenFriendRequests: unseenFriendRequests ?? this.unseenFriendRequests,
      unseenAlbumInvites: unseenAlbumInvites ?? this.unseenAlbumInvites,
      unseenGenericNoti: unseenGenericNoti ?? this.unseenGenericNoti,
    );
  }

  List<FriendRequestNotification> get friendRequestList =>
      List.from(friendRequestMap.values)
        ..sort((a, b) => b.status.val.compareTo(a.status.val));

  bool get unreadNotificationTabs {
    return unseenFriendRequests || unseenAlbumInvites || unseenGenericNoti;
  }

  List<AlbumInviteNotification> get albumInviteList =>
      List.from(albumInviteMap.values)
        ..sort((a, b) => b.status.val.compareTo(a.status.val));

  List<Notification> get allNotifications => allNotificationMap.values.toList()
    ..sort((a, b) => b.receivedDateTime.compareTo(a.receivedDateTime));

  bool tabShowNotification(int index) {
    switch (index) {
      case 0:
        return unseenGenericNoti;
      case 1:
        return unseenAlbumInvites;
      case 2:
        return unseenFriendRequests;
      default:
        return false;
    }
  }

  @override
  List<Object> get props => [
        currentIndex,
        friendRequestMap,
        albumInviteMap,
        allNotificationMap,
        friendRequestList,
        exception,
        unseenFriendRequests,
        unseenAlbumInvites,
        unseenGenericNoti,
      ];
}
