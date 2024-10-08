import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/services/firebase_service.dart';
import 'dart:developer' as developer;

part 'firebase_notifications_state.dart';

class FirebaseNotificationsCubit extends Cubit<FirebaseNotificationsState> {
  final User user;
  final NotificationSettings settings;
  late final StreamSubscription _firebaseSubscription;
  FirebaseNotificationsCubit({
    required this.user,
    required this.settings,
  }) : super(const FirebaseNotificationsState()) {
    _checkForMessageAndInteract();
    FirebaseMessaging.instance.getToken().then((onValue) => print(onValue));

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _updateDBToken();
    }

    _firebaseSubscription = FirebaseMessaging.onMessage.listen((message) {
      String type = message.data['type'];
      switch (type) {
        case "album-invite":
          AlbumInviteNotification notification =
              AlbumInviteNotification.fromMap(message.data);
          print(notification.albumName);
        default:
      }
    });
  }

  Future<void> _checkForMessageAndInteract() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message == null) return;

    // handle logic for messages - push to notification page or content
    developer.log('message handled');
  }

  Future<void> _updateDBToken() async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    String deviceID = await FlutterUdid.udid;

    if (firebaseToken == null) return;

    FirebaseService.putFirebaseToken(user.token, deviceID, firebaseToken);
  }

  @override
  Future<void> close() {
    _firebaseSubscription.cancel();
    return super.close();
  }
}
