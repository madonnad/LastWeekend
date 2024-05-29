import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  static Future<void> putFirebaseToken(
      String token, String deviceID, String firebaseToken) async {
    String urlString =
        "${dotenv.env['URL']}/fcm?token=$firebaseToken&device_id=$deviceID";
    Uri url = Uri.parse(urlString);

    final Map<String, String> headers = {'Authorization': 'Bearer $token'};

    final response = await http.put(url, headers: headers);

    if (response.statusCode == 200) {
      return;
    }
    throw HttpException(
        "Failed to put firebase token in DB: ${response.statusCode}");
  }
}
