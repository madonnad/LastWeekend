import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class EngagementService {
  static Future<(List<Comment>, String?)> getImageComments(
      String token, String imageId) async {
    List<Comment> commentList = [];
    String? error;

    String urlString = "${dotenv.env['URL']}/image/comment?image_id=$imageId";
    Uri url = Uri.parse(urlString);

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
        return (commentList, error);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (commentList, "$code: $body");
    } catch (e) {
      return (commentList, e.toString());
    }
  }

  static Future<(Comment?, String?)> postNewComment(
      String token, String imageID, String comment) async {
    Map<String, dynamic> body = {'image_id': imageID, 'comment': comment};
    String encodedBody = jsonEncode(body);

    String urlString = "${dotenv.env['URL']}/image/comment";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        return (Comment.fromJson(body), null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (null, "$code: $body");
    } catch (e) {
      return (null, e.toString());
    }
  }

  static Future<bool> markCommentSeen(String token, String commentID) async {
    String urlString = "${dotenv.env['URL']}/image/comment/seen?id=$commentID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      developer.log(e.toString());
      return false;
    }
  }

  static Future<bool> markNotificationSeen(
      String token, String notificationID) async {
    String urlString = "${dotenv.env['URL']}/notifications?id=$notificationID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      developer.log(e.toString());
      return false;
    }
  }

  static Future<(int, String?)> likePhoto(String token, String imageID) async {
    String urlString = "${dotenv.env['URL']}/image/like?image_id=$imageID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData;
        return (count, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (0, "$code: $body");
    } catch (e) {
      return (0, e.toString());
    }
  }

  static Future<(int, String?)> unlikePhoto(
      String token, String imageID) async {
    String urlString = "${dotenv.env['URL']}/image/like?image_id=$imageID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData['new_count'];
        return (count, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (0, "$code: $body");
    } catch (e) {
      return (0, e.toString());
    }
  }

  static Future<(int, String?)> upvotePhoto(
      String token, String imageID) async {
    String urlString = "${dotenv.env['URL']}/image/upvote?image_id=$imageID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData;
        return (count, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (0, "$code: $body");
    } catch (e) {
      return (0, e.toString());
    }
  }

  static Future<(int, String?)> removeUpvoteFromPhoto(
      String token, String imageID) async {
    String urlString = "${dotenv.env['URL']}/image/upvote?image_id=$imageID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData["new_count"];
        return (count, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (0, "$code: $body");
    } catch (e) {
      return (0, e.toString());
    }
  }
}
