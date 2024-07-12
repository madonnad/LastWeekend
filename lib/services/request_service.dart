import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RequestService {
  // Friend Requests
  static Future<(bool, String?)> sendFriendRequest(
      String token, String uid) async {
    String urlString = "${dotenv.env['URL']}/friend-request?id=$uid";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

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

  static Future<(bool, String?)> acceptFriendRequest(
      String token, String senderID, String requestID) async {
    String urlString =
        "${dotenv.env['URL']}/friend-request?id=$senderID&request_id=$requestID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.put(url, headers: headers);

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

  static Future<(bool, String?)> deleteFriendRequest(
      String token, String requestID) async {
    String urlString = "${dotenv.env['URL']}/friend-request?id=$requestID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.delete(url, headers: headers);

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

  static Future<bool> markFriendRequestAsSeen(
      String token, String requestID) async {
    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/friend-request', {"id": requestID});
    String urlString = "${dotenv.env['URL']}/friend-request?id=$requestID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<bool> markAlbumInviteResponsetAsSeen(
      String token, String requestID) async {
    // var url = Uri.https(
    //     dotenv.env['DOMAIN'] ?? '', '/album-invite', {"id": requestID});
    String urlString = "${dotenv.env['URL']}/album-invite?id=$requestID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Album Invites
  static Future<(bool, String?)> acceptAlbumInvite(
      String token, String requestID) async {
    String urlString =
        "${dotenv.env['URL']}/album-invite?request_id=$requestID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.put(url, headers: headers);

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

  static Future<(bool, String?)> denyAlbumInvite(
      String token, String requestID) async {
    String urlString =
        "${dotenv.env['URL']}/album-invite?request_id=$requestID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    try {
      final response = await http.delete(url, headers: headers);

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
}
