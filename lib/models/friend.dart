import 'package:equatable/equatable.dart';
import 'package:shared_photo/utils/api_variables.dart';

class Friend extends Equatable {
  final String uid;
  final String firstName;
  final String lastName;
  final DateTime friendSince;

  const Friend({
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

  Map<String, dynamic> toJson() {
    return {
      "user_id": uid,
      "first_name": firstName,
      "last_name": lastName,
    };
  }

  String get imageReq {
    String requestUrl = "$goRepoDomain/image?id=$uid";

    return requestUrl;
  }

  @override
  List<Object?> get props => [uid];
}
