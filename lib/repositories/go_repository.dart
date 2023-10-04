import 'dart:convert';

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

  Future<bool> postNewAlbum(String token, CreateAlbumState state) async {
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

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
