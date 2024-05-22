import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'firebase_notifications_state.dart';

class FirebaseNotificationsCubit extends Cubit<FirebaseNotificationsState> {
  FirebaseNotificationsCubit() : super(const FirebaseNotificationsState());
}
