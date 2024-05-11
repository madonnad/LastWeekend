import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:http/http.dart' as http;

class EngagementService {
  static Future<List<Comment>> getImageComments(
      String token, String imageId) async {
    List<Comment> commentList = [];

    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/image/comment', {'image_id': imageId});

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
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: #${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return commentList;
  }

  static Future<Comment?> postNewComment(
      String token, String imageID, String comment) async {
    Map<String, dynamic> body = {'image_id': imageID, 'comment': comment};
    String encodedBody = jsonEncode(body);

    //var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/image/comment');
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
        return Comment.fromJson(body);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<bool> markCommentSeen(String token, String commentID) async {
    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/image/comment/seen', {"id": commentID});
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
      print(e.toString());
      return false;
    }
  }

  static Future<bool> markNotificationSeen(
      String token, String notificationID) async {
    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/notifications', {"id": notificationID});
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
      print(e.toString());
      return false;
    }
  }

  static Future<int> likePhoto(String token, String imageID) async {
    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/image/like', {"image_id": imageID});
    String urlString = "${dotenv.env['URL']}/image/like?image_id=$imageID";
    Uri url = Uri.parse(urlString);


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
    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/image/like', {"image_id": imageID});
    String urlString = "${dotenv.env['URL']}/image/like?image_id=$imageID";
    Uri url = Uri.parse(urlString);


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
    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/image/upvote', {"image_id": imageID});
    String urlString = "${dotenv.env['URL']}/image/upvote?image_id=$imageID";
    Uri url = Uri.parse(urlString);


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
    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/image/upvote', {"image_id": imageID});
    String urlString = "${dotenv.env['URL']}/image/upvote?image_id=$imageID";
    Uri url = Uri.parse(urlString);


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
