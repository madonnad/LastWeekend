import 'dart:convert';

import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<Friend>> getFriendsList(String token) async {
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
}
