import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/album.dart';

class GoRepository {
  Future<List<Album>> getAuthenticatedUsersAlbums(String token) async {
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
}
