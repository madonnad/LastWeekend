import 'package:shared_photo/utils/api_variables.dart';
import 'package:http/http.dart' as http;

class RequestService {
  static Future<bool> sendFriendRequest(String token, String uid) async {
    var url = Uri.http(domain, '/friend-request', {'id': uid});
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };

    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
