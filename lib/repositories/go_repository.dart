import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/search_result.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:web_socket_channel/io.dart';

class GoRepository {
  String token;

  GoRepository({required this.token});

  Stream<String> webSocketConnection() async* {
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final wsURL = Uri.parse('ws://0.0.0.0:2525/ws');
    var connection = IOWebSocketChannel.connect(wsURL, headers: headers);

    await for (final message in connection.stream) {
      String text = message.toString();
      yield text;
    }
  }

  Future<List<SearchResult>> searchLookup({required String lookup}) async {
    List<SearchResult> searchResults = [];

    var url = Uri.http(domain, '/search', {"lookup": lookup});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        return searchResults;
      }

      for (var item in jsonData) {
        String resultType = item['type'];

        switch (resultType) {
          case 'album':
            searchResults.add(AlbumSearch.fromMap(item, headers));
          case 'user':
            searchResults.add(UserSearch.fromMap(item, headers));
          default:
            continue;
        }
      }
      return searchResults;
    }
    throw HttpException(
        "Failed to full text search with status: ${response.statusCode}");
  }

  Future<List<Notification>> getNotifications() async {
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
        notificationList.add(FriendRequestNotification.fromMap(item));
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

  Future<String?> postNewAlbum(CreateAlbumState state) async {
    Map<String, dynamic> albumInformation = state.toJson();
    String encodedBody = json.encode(albumInformation);

    var url = Uri.http(domain, '/user/album');
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        return body['album_cover_id'];
      }
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> postNewImage(CapturedImage image) async {
    var url = Uri.http(domain, '/user/image');
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    String imageId;
    Map<String, dynamic> capturedImageData = image.toJson();
    String encodedBody = json.encode(capturedImageData);

    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        imageId = body['image_id'];

        bool upload =
            await uploadImageWithID(token, image.imageXFile.path, imageId);
        if (upload = false) {
          //need to handle removing the information from the DB that failed or try uploading the image again later
          throw "Upload failed";
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: #${response.body}');
        throw "status code not 200";
      }
    } catch (e) {
      print(e);
      return false;
    }

    if (image.addToRecap) {
      bool addImage = await addImageToRecap(imageId);

      if (addImage == false) {
        print("failed to add to recap");
        return false;
      }
    }

    return true;
  }

  Future<bool> addImageToRecap(String imageId) async {
    var url = Uri.http(domain, '/user/recap', {'id': imageId});
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Comment>> getImageComments(String imageId) async {
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

  // This function only uploads the image with a given ID
  Future<bool> uploadImageWithID(
      String token, String imagePath, String imageId) async {
    var url = Uri.http(domain, '/upload', {'id': imageId});
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    final Map<String, String> gcpHeader = {
      "Content-Type": "application/octet-stream"
    };

    Uint8List imageBytes = await File(imagePath).readAsBytes();

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final gcpSignedUrl = Uri.parse(response.body);
        final secureUrl = Uri.https(gcpSignedUrl.authority, gcpSignedUrl.path,
            gcpSignedUrl.queryParameters);
        final uploadResponse =
            await http.put(secureUrl, headers: gcpHeader, body: imageBytes);

        if (uploadResponse.statusCode == 200) {
          return true;
        }
        response = uploadResponse;
      }

      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> likePhoto(String token, String imageID) async {
    var url = Uri.http(domain, '/image/like', {"image_id": imageID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData["count"];
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

  Future<int> unlikePhoto(String token, String imageID) async {
    var url = Uri.http(domain, '/image/like', {"image_id": imageID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData["count"];
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

  Future<int> upvotePhoto(String token, String imageID) async {
    var url = Uri.http(domain, '/image/upvote', {"image_id": imageID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData["count"];
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

  Future<int> removeUpvoteFromPhoto(String token, String imageID) async {
    var url = Uri.http(domain, '/image/upvote', {"image_id": imageID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int count = jsonData["count"];
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

  Future<void> acceptFriendRequest(String token, String friendID) async {
    var url =
        Uri.http(domain, '/notifications/friend', {"friend_id": friendID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to accept the friend request with status: ${response.statusCode}");
  }

  Future<void> denyFriendRequest(String token, String friendID) async {
    var url =
        Uri.http(domain, '/notifications/friend', {"friend_id": friendID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to delete the friend request with status: ${response.statusCode}");
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
