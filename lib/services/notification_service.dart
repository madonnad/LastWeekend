import 'dart:convert';

import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  Future<List<Notification>> getNotifications(String token) async {
    final List<Notification> notificationList = [];

    var url = Uri.http(domain, '/notifications');
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

      for (var item in friendRequestList) {
        notificationList.add(FriendRequestNotification.fromMap(item));
      }
      for (var item in albumInviteList) {
        print(item.toString());
        notificationList.add(AlbumInviteNotification.fromMap(item));
      }

      for (var item in albumRequestResponseList) {
        print(item.toString());
        notificationList.add(AlbumInviteNotification.fromMap(item));
      }

      return notificationList;
    }
    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');

    return notificationList;
  }

  static Future<bool> markNotificationSeen(
      String token, String notificationID) async {
    var url = Uri.http(domain, '/notifications', {"id": notificationID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
