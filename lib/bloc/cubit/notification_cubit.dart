import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/repositories/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationRepository notificationRepository;

  NotificationCubit({required this.notificationRepository})
      : super(const NotificationState()) {
    initalizeNotifications();

    notificationRepository.realtimeRepository.notificationStream
        .listen((event) {
      Map<String, Notification> tempAllNotifications =
          Map.from(state.allNotifications);
      switch (event.runtimeType) {
        case AlbumInviteNotification:
          AlbumInviteNotification notification =
              event as AlbumInviteNotification;
          tempAllNotifications[notification.notificationID] = notification;
          emit(state.copyWith(
            allNotifications: tempAllNotifications,
            unreadNotificationTabs: [false, true, false],
          ));
        case FriendRequestNotification:
          FriendRequestNotification notification =
              event as FriendRequestNotification;
          tempAllNotifications[notification.notificationID] = notification;
          emit(state.copyWith(
            allNotifications: tempAllNotifications,
            unreadNotificationTabs: [false, false, true],
          ));
        case GenericNotification:
          GenericNotification notification = event as GenericNotification;
          tempAllNotifications[notification.notificationID] = notification;
          emit(state.copyWith(
            allNotifications: tempAllNotifications,
            unreadNotificationTabs: [true, false, false],
          ));
      }
    });
  }

  void initalizeNotifications() {
    Map<String, Notification> allNotifications =
        notificationRepository.globalNotifications;
    emit(state.copyWith(allNotifications: allNotifications));
  }

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void clearTabNotifications(int index) {
    if (state.unreadNotificationTabs[index] == true) {
      List<bool> unreadNotificationTabs =
          List.from(state.unreadNotificationTabs);
      unreadNotificationTabs[index] = false;
      emit(state.copyWith(unreadNotificationTabs: unreadNotificationTabs));
    }
  }
}
