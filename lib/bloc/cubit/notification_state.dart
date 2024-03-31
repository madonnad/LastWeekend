part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final int currentIndex;
  final List<bool> unreadNotificationTabs;
  final Map<String, FriendRequestNotification> friendRequestMap;
  final Map<String, AlbumInviteNotification> albumInviteMap;
  final Map<String, GenericNotification> genericNotificationMap;
  final String exception;

  const NotificationState({
    this.currentIndex = 0,
    this.unreadNotificationTabs = const [false, false, false],
    this.friendRequestMap = const {},
    this.albumInviteMap = const {},
    this.genericNotificationMap = const {},
    this.exception = '',
  });

  NotificationState copyWith({
    int? currentIndex,
    List<bool>? unreadNotificationTabs,
    Map<String, FriendRequestNotification>? friendRequestMap,
    Map<String, AlbumInviteNotification>? albumInviteMap,
    Map<String, GenericNotification>? genericNotificationMap,
    String? exception,
  }) {
    return NotificationState(
      currentIndex: currentIndex ?? this.currentIndex,
      unreadNotificationTabs:
          unreadNotificationTabs ?? this.unreadNotificationTabs,
      friendRequestMap: friendRequestMap ?? this.friendRequestMap,
      albumInviteMap: albumInviteMap ?? this.albumInviteMap,
      genericNotificationMap:
          genericNotificationMap ?? this.genericNotificationMap,
      exception: exception ?? this.exception,
    );
  }

  List<FriendRequestNotification> get friendRequestList =>
      List.from(friendRequestMap.values)
        ..sort((a, b) => b.status.val.compareTo(a.status.val));

  @override
  List<Object> get props => [
        currentIndex,
        unreadNotificationTabs,
        friendRequestMap,
        albumInviteMap,
        genericNotificationMap,
        friendRequestList,
        exception,
      ];
}
