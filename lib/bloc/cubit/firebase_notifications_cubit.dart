import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/services/firebase_service.dart';

part 'firebase_notifications_state.dart';

class FirebaseNotificationsCubit extends Cubit<FirebaseNotificationsState> {
  final User user;
  final NotificationSettings settings;
  FirebaseNotificationsCubit({
    required this.user,
    required this.settings,
  }) : super(const FirebaseNotificationsState()) {
    _checkForMessageAndInteract();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _updateDBToken();
    }
  }

  Future<void> _checkForMessageAndInteract() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message == null) return;

    // handle logic for messages - push to notification page or content
    print('message handled');
  }

  Future<void> _updateDBToken() async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    String deviceID = await FlutterUdid.udid;

    if (firebaseToken == null) return;

    FirebaseService.putFirebaseToken(user.token, deviceID, firebaseToken);
  }
}
