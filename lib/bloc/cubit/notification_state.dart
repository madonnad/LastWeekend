part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final int currentIndex;
  final List<bool> unreadNotificationTabs;

  const NotificationState(
      {this.currentIndex = 0,
      this.unreadNotificationTabs = const [true, false, false]});

  NotificationState copyWith({
    int? currentIndex,
    List<bool>? unreadNotificationTabs,
  }) {
    return NotificationState(
      currentIndex: currentIndex ?? this.currentIndex,
      unreadNotificationTabs:
          unreadNotificationTabs ?? this.unreadNotificationTabs,
    );
  }

  @override
  List<Object> get props => [currentIndex, unreadNotificationTabs];
}
