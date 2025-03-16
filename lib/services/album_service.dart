import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class AlbumService {
  static Future<(Album?, String?)> postNewAlbum(
      String token, CreateEventState state) async {
    Map<String, dynamic> albumInformation = state.toJson();
    String encodedBody = json.encode(albumInformation);

    String urlString = "${dotenv.env['URL']}/album";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        return (Album.fromMap(body), null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (null, "$code: $body");
    } catch (e) {
      return (null, e.toString());
    }
  }

  static Future<List<Album>> getAuthUsersAlbums(String token) async {
    final List<Album> albums = [];

    String urlString = "${dotenv.env['URL']}/user/album";
    Uri url = Uri.parse(urlString);

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

  static Future<List<Album>> getRevealedAlbumsByAlbumID(
      String token, List<String> albumIds) async {
    final List<Album> albums = [];

    String urlString = "${dotenv.env['URL']}/album/revealed";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};
    String encodedBody = json.encode(albumIds);

    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final jsonData = json.decode(responseBody);

        for (var item in jsonData) {
          Album album = Album.fromMap(item);
          if (album.albumId == "4ae4216a-5305-4d74-ba45-3af385a5d630") {
            print(album.guests.length);
          }
          albums.add(album);
        }

        return albums;
      }
      return albums;
    } catch (e) {
      developer.log(e.toString());
      return albums;
    }
  }

  static Future<List<Album>> getFeedAlbums(String token) async {
    final List<Album> albums = [];
    String urlString = "${dotenv.env['URL']}/feed";
    Uri url = Uri.parse(urlString);

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

    if (response.statusCode == 204) {
      return albums;
    }
    String code = response.statusCode.toString();
    String body = response.body;
    developer.log("$code: $body");
    return albums;
  }

  static Future<(bool, Album?)> getAlbumByID(
      String token, String albumID) async {
    Album album = Album.empty;

    String urlString = "${dotenv.env['URL']}/album?album_id=$albumID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        final jsonData = json.decode(responseBody);
        if (jsonData == null) {
          return (false, null);
        }

        album = Album.fromMap(jsonData);

        return (true, album);
      }
      return (false, null);
    } catch (e) {
      return (false, null);
    }
  }

  static Future<(bool, String?)> postSingleAlbumRequest(
      String token, String albumID, String guestID) async {
    String urlString =
        "${dotenv.env['URL']}/album/guests?album_id=$albumID&guest_id=$guestID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return (true, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (false, "$code: $body");
    } catch (e) {
      return (false, e.toString());
    }
  }

  // static Future<List<Guest>> updateGuestList(
  //     String token, String albumID) async {
  //   List<Guest> guests = [];

  //   String urlString = "${dotenv.env['URL']}/album/guests?album_id=$albumID";
  //   Uri url = Uri.parse(urlString);

  //   final Map<String, String> headers = {'Authorization': 'Bearer $token'};

  //   try {
  //     final response = await http.get(url, headers: headers);

  //     if (response.statusCode == 200) {
  //       final responseBody = response.body;
  //       final jsonData = json.decode(responseBody);

  //       for (var item in jsonData) {
  //         guests.add(Guest.fromMap(item));
  //       }
  //     }
  //     return guests;
  //   } catch (e) {
  //     developer.log(e.toString());
  //     return guests;
  //   }
  // }

  static Future<(bool, String?)> updateAlbumVisibility(
      String token, String albumID, String visibility) async {
    String urlString =
        "${dotenv.env['URL']}/album/visibility?album_id=$albumID&visibility=$visibility";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return (true, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (false, "$code: $body");
    } catch (e) {
      developer.log(e.toString());
      return (false, e.toString());
    }
  }

  static Future<(bool, String?)> updateEventOwnership(
      String token, String userID, String albumID) async {
    String urlString =
        "${dotenv.env['URL']}/user/album?user_id=$userID&album_id=$albumID";
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    Uri url = Uri.parse(urlString);

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return (true, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (false, "$code: $body");
    } catch (e) {
      developer.log(e.toString());
      return (false, e.toString());
    }
  }

  static Future<(bool, String?)> deleteLeaveEvent(
      String token, String albumID) async {
    String urlString = "${dotenv.env['URL']}/user/album?album_id=$albumID";
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    Uri url = Uri.parse(urlString);

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        return (true, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (false, "$code: $body");
    } catch (e) {
      developer.log(e.toString());
      return (false, e.toString());
    }
  }

  static Future<(bool, String?)> deleteEvent(
      String token, String albumID) async {
    String urlString = "${dotenv.env['URL']}/album?album_id=$albumID";
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    Uri url = Uri.parse(urlString);

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        return (true, null);
      }
      String code = response.statusCode.toString();
      String body = response.body;
      return (false, "$code: $body");
    } catch (e) {
      developer.log(e.toString());
      return (false, e.toString());
    }
  }
}
