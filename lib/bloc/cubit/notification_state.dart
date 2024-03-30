part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final int currentIndex;
  final List<bool> unreadNotificationTabs;
  final Map<String, dynamic> allNotifications;

  const NotificationState({
    this.currentIndex = 0,
    this.unreadNotificationTabs = const [false, false, false],
    this.allNotifications = const {},
  });

  NotificationState copyWith({
    int? currentIndex,
    List<bool>? unreadNotificationTabs,
    Map<String, dynamic>? allNotifications,
  }) {
    return NotificationState(
      currentIndex: currentIndex ?? this.currentIndex,
      unreadNotificationTabs:
          unreadNotificationTabs ?? this.unreadNotificationTabs,
      allNotifications: allNotifications ?? this.allNotifications,
    );
  }

  List<AlbumInviteNotification> get albumInviteNotifications {
    return allNotifications.values
        .whereType<AlbumInviteNotification>()
        .toList();
  }

  List<FriendRequestNotification> get friendRequestNotifications {
    return allNotifications.values
        .whereType<FriendRequestNotification>()
        .toList();
  }

  @override
  List<Object> get props => [
        currentIndex,
        unreadNotificationTabs,
        allNotifications,
      ];
}
