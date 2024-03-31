part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final int currentIndex;
  final List<bool> unreadNotificationTabs;
  final Map<String, dynamic> friendRequestMap;
  final Map<String, dynamic> albumInviteMap;
  final Map<String, dynamic> genericNotificationMap;
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
    Map<String, dynamic>? friendRequestMap,
    Map<String, dynamic>? albumInviteMap,
    Map<String, dynamic>? genericNotificationMap,
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
      friendRequestMap.values.whereType<FriendRequestNotification>().toList();

  @override
  List<Object> get props => [
        currentIndex,
        unreadNotificationTabs,
        friendRequestMap,
        albumInviteMap,
        genericNotificationMap,
        exception,
      ];
}
