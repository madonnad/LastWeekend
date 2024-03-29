import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/repositories/notification_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationRepository notificationRepository;

  NotificationCubit({required this.notificationRepository})
      : super(const NotificationState()) {
    notificationRepository.realtimeRepository.notificationStream
        .listen((event) {
      print("Notification Received");
    });
  }
}
