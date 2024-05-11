import 'package:flutter_dotenv/flutter_dotenv.dart';

class Engager {
  final String uid;
  final String firstName;
  final String lastName;

  Engager({
    required this.uid,
    required this.firstName,
    required this.lastName,
  });

  factory Engager.fromMap(Map<String, dynamic> json) {
    return Engager(
      uid: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  String get imageReq {
    String requestUrl = "${dotenv.env['URL']}/image?id=$uid";

    return requestUrl;
  }
}
