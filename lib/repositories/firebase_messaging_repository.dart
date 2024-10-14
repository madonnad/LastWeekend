import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/notification_repository/notification_repository.dart';
import 'dart:developer' as developer;

import 'package:shared_photo/services/firebase_service.dart';

class FirebaseMessagingRepository {
  final User user;
  final NotificationSettings settings;
  final NotificationRepository notificationRepository;
  late final StreamSubscription _firebaseSubscription;
  final _messageController = StreamController();

  Stream get messageStream => _messageController.stream;

  FirebaseMessagingRepository({
    required this.user,
    required this.settings,
    required this.notificationRepository,
  }) {
    _checkForMessageAndInteract();

    _firebaseSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Map<String, dynamic> messageMap = message.data;
      String type = messageMap['type'];
      switch (type) {
        case "album-invite":
          notificationRepository.refreshNotificationsAndNavigate(type);
        case "friend-request":
          notificationRepository.refreshNotificationsAndNavigate(type);
        default:
      }
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _updateDBToken();
    }
  }

  Future<void> _checkForMessageAndInteract() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message == null) return;

    print("Message Data: ${message.data}");

    // handle logic for messages - push to notification page or content
    developer.log('message handled');
  }

  Future<void> _updateDBToken() async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    String deviceID = await FlutterUdid.udid;

    if (firebaseToken == null) return;

    FirebaseService.putFirebaseToken(user.token, deviceID, firebaseToken);
  }

  void closeFirebaseStream() {
    _firebaseSubscription.cancel();
  }
}
