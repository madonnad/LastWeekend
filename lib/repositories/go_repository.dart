import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_photo/models/album.dart';

class GoRepository {
  Future<List<Album>> getUsersAlbums(String token) async {
    final List<Album> albums = [];
    var url = Uri.http('0.0.0.0:2525', '/user/album');
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      final jsonData = jsonDecode(responseBody);

      for (var item in jsonData) {
        Album album = Album.fromMap(item);
        albums.add(album);
      }
      print(albums);
      return albums;
    }
    print('Request failed with status: ${response.statusCode}');
    print('Response body: #${response.body}');
    return albums;
  }
}
