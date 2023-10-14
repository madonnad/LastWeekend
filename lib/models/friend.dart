import 'package:shared_photo/utils/api_variables.dart';

class Friend {
  final String uid;
  final String firstName;
  final String lastName;
  final DateTime friendSince;

  Friend({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.friendSince,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      uid: json['user_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      friendSince: DateTime.parse(json['friends_since']),
    );
  }

  String get imageReq {
    String requestUrl = "$goRepoDomain/image?id=$uid";

    return requestUrl;
  }
}
