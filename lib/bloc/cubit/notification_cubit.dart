import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  RealtimeRepository realtimeRepository;

  NotificationCubit({required this.realtimeRepository})
      : super(const NotificationState()) {
    realtimeRepository.notificationStream.listen((event) {
      print("Notification Received");
    });
  }
}
