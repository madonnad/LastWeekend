import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class NotificationService {
  Future<List<Notification>> getNotifications(String token) async {
    final List<Notification> notificationList = [];

    //var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/notifications');
    String urlString = "${dotenv.env['URL']}/notifications";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        return notificationList;
      }
      List<dynamic> albumInviteList = jsonData['album_invites'] ?? [];
      List<dynamic> albumRequestResponseList =
          jsonData['album_request_responses'] ?? [];
      List<dynamic> friendRequestList = jsonData['friend_requests'] ?? [];
      List<dynamic> engagementNotifications =
          jsonData['engagement_notification'] ?? [];
      List<dynamic> commentNotifications =
          jsonData['comment_notifications'] ?? [];

      for (var item in friendRequestList) {
        notificationList.add(FriendRequestNotification.fromMap(item));
      }
      for (var item in albumInviteList) {
        notificationList.add(AlbumInviteNotification.fromMap(item));
      }
      for (var item in albumRequestResponseList) {
        //print(item.toString());
        notificationList.add(AlbumInviteNotification.fromMap(item));
      }
      for (var item in engagementNotifications) {
        notificationList.add(EngagementNotification.fromMap(item, 'ADD'));
      }

      for (var item in commentNotifications) {
        notificationList.add(CommentNotification.fromMap(item, 'ADD'));
      }

      return notificationList;
    }
    String code = response.statusCode.toString();
    String body = response.body;
    developer.log("$code: $body");

    return notificationList;
  }
}
