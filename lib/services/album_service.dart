import 'dart:convert';
import 'dart:io';

import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:http/http.dart' as http;

class AlbumService {
  static Future<Album?> postNewAlbum(
      String token, CreateAlbumState state) async {
    // print(state.toJson());
    Map<String, dynamic> albumInformation = state.toJson();
    print(albumInformation);
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
        return Album.fromMap(body);
      }
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<List<Album>> getUsersAlbums(String token) async {
    final List<Album> albums = [];
    var url = Uri.http(domain, '/user/album');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = json.decode(responseBody);
      if (jsonData == null) {
        return albums;
      }

      for (var item in jsonData) {
        Album album = Album.fromMap(item);
        albums.add(album);
      }
      //print(albums);
      return albums;
    }
    throw HttpException(
        "Failed to get users albums with status: ${response.statusCode}");
  }

  static Future<List<Album>> getFeedAlbums(String token) async {
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
      return albums;
    }
    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return albums;
  }
}
