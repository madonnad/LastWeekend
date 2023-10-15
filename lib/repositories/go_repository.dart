import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:web_socket_channel/io.dart';

class GoRepository {
  Stream<String> webSocketConnection(String token) async* {
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final wsURL = Uri.parse('ws://0.0.0.0:2525/ws');
    var connection = IOWebSocketChannel.connect(wsURL, headers: headers);

    await for (final message in connection.stream) {
      String text = message.toString();
      yield text;
    }
  }

  Future<List<Album>> getUsersAlbums(String token) async {
    final List<Album> albums = [];
    var url = Uri.http('0.0.0.0:2525', '/user/album');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);

      for (var item in jsonData) {
        Album album = Album.fromMap(item);
        albums.add(album);
      }
      //print(albums);
      return albums;
    }
    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return albums;
  }

  Future<List<Image>> getUserImages(String token) async {
    final List<Image> images = [];
    var url = Uri.http('0.0.0.0:2525', '/user/image');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);

      for (var item in jsonData) {
        Image image = Image.fromMap(item);
        images.add(image);
      }
      //print(images);
      return images;
    }

    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return images;
  }

  Future<List<Friend>> getFriendsList(String token) async {
    final List<Friend> friends = [];

    var url = Uri.http('0.0.0.0:2525', '/user/friend');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        return friends;
      }

      for (var item in jsonData) {
        friends.add(Friend.fromJson(item));
      }
      //print(friends);
      return friends;
    }
    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return friends;
  }

  Future<List<Album>> getFeedAlbums(String token) async {
    final List<Album> albums = [];
    var url = Uri.http('0.0.0.0:2525', '/feed');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);

      for (var item in jsonData) {
        Album album = Album.fromMap(item);
        albums.add(album);
      }
      //print(albums);
      return albums;
    }
    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return albums;
  }

  Future<List<Notification>> getNotifications(String token) async {
    final List<Notification> notificationList = [];

    var url = Uri.http('0.0.0.0:2525', '/notifications');
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

  Future<String?> postNewAlbum(String token, CreateAlbumState state) async {
    Map<String, dynamic> albumInformation = state.toJson();
    String encodedBody = json.encode(albumInformation);

    var url = Uri.http('0.0.0.0:2525', '/user/album');
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

  Future<bool> uploadNewImage(
      String token, String imagePath, String imageId) async {
    var url = Uri.http('0.0.0.0:2525', '/upload', {'id': imageId});
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

  Future<void> acceptFriendRequest(String token, String friendID) async {
    var url = Uri.http(
        '0.0.0.0:2525', '/notifications/friend', {"friend_id": friendID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to accept the friend request with status: ${response.statusCode}");
  }

  Future<void> denyFriendRequest(String token, String friendID) async {
    var url = Uri.http(
        '0.0.0.0:2525', '/notifications/friend', {"friend_id": friendID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to delete the friend request with status: ${response.statusCode}");
  }

  Future<void> acceptAlbumInvite(String token, String albumID) async {
    var url =
        Uri.http('0.0.0.0:2525', '/notifications/album', {"album_id": albumID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to accept the friend request with status: ${response.statusCode}");
  }

  Future<void> denyAlbumInvite(String token, String albumID) async {
    var url =
        Uri.http('0.0.0.0:2525', '/notifications/album', {"album_id": albumID});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to accept the friend request with status: ${response.statusCode}");
  }
}
