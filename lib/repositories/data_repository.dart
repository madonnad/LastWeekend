import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/utils/api_variables.dart';

class DataRepository {
  String token;

  DataRepository({required this.token});

  Future<List<Image>> getUserImages(String token) async {
    final List<Image> images = [];
    var url = Uri.http(domain, '/user/image');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        return images;
      }

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

    var url = Uri.http(domain, '/user/friend');
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
    var url = Uri.http(domain, '/feed');
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
}
