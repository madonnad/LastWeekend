import 'dart:convert';
import 'dart:io';

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

      List<dynamic> summaryNotificationList =
          jsonData['summary_notifications'] ?? [];
      List<dynamic> albumInviteList = jsonData['album_invites'] ?? [];
      List<dynamic> friendRequestList = jsonData['friend_requests'] ?? [];

      for (var item in friendRequestList) {
        notificationList.add(
          FriendRequestNotification.fromMap(item),
        );
      }
      for (var item in albumInviteList) {
        notificationList.add(AlbumInviteNotification.fromMap(item));
      }
      for (var item in summaryNotificationList) {
        notificationList.add(SummaryNotification.fromMap(item));
      }

      return notificationList;
    }
    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');

    return notificationList;
  }

  Future<void> acceptAlbumInvite(String token, String albumID) async {
    var url = Uri.http(domain, '/notifications/album', {"album_id": albumID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to accept the friend request with status: ${response.statusCode}");
  }

  Future<void> denyAlbumInvite(String token, String albumID) async {
    var url = Uri.http(domain, '/notifications/album', {"album_id": albumID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to accept the friend request with status: ${response.statusCode}");
  }
}
