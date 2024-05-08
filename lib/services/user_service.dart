import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<bool> createUserEntry(
      String token, String firstName, String lastName, String email) async {
    final Map<String, String> requestBodyJson = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
    };
    String encodedBody = json.encode(requestBodyJson);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/user');
    try {
      final response =
          await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response body: #${response.body}');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<List<Friend>> getFriendsList(String token) async {
    final List<Friend> friends = [];

    var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/user/friend');
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

  static Future<AnonymousFriend> getSearchedUser(
      String token, String uid) async {
    var url = Uri.https(dotenv.env['DOMAIN'] ?? '', '/user/id', {'id': uid});
    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseBody = response.body;

        final jsonData = json.decode(responseBody);

        return AnonymousFriend.fromJson(jsonData);
      }
      print('Request failed with status: ${response.statusCode}');
      print('Response body: #${response.body}');
      return AnonymousFriend.empty;
    } catch (e) {
      print(e);
      return AnonymousFriend.empty;
    }
  }
}
