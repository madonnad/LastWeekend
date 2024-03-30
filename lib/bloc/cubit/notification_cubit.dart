import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/repositories/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationRepository notificationRepository;
  NotificationCubit({required this.notificationRepository})
      : super(const NotificationState());

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
