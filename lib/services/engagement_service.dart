import 'dart:convert';

import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:http/http.dart' as http;

class EngagementService {
  static Future<List<Comment>> getImageComments(
      String token, String imageId) async {
    List<Comment> commentList = [];

    var url = Uri.http(domain, '/image/comment', {'image_id': imageId});
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null) {
          for (var item in jsonData) {
            commentList.add(Comment.fromJson(item));
          }
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: #${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return commentList;
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

  static Future<int> likePhoto(String token, String imageID) async {
    var url = Uri.http(domain, '/image/like', {"image_id": imageID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData;
        return count;
      }
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<int> unlikePhoto(String token, String imageID) async {
    var url = Uri.http(domain, '/image/like', {"image_id": imageID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData['new_count'];
        return count;
      }
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<int> upvotePhoto(String token, String imageID) async {
    var url = Uri.http(domain, '/image/upvote', {"image_id": imageID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData;
        return count;
      }
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  static Future<int> removeUpvoteFromPhoto(String token, String imageID) async {
    var url = Uri.http(domain, '/image/upvote', {"image_id": imageID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData["new_count"];
        return count;
      }
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
