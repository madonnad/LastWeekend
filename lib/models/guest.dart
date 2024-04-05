import 'package:shared_photo/utils/api_variables.dart';

enum InviteStatus { accept, decline, pending }

class Guest {
  final String uid;
  final String firstName;
  final String lastName;
  final InviteStatus status;

  Guest({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.status,
  });

  factory Guest.fromMap(Map<String, dynamic> map) {
    late InviteStatus status;
    switch (map['status']) {
      case 'accepted':
        status = InviteStatus.accept;
      case 'pending':
        status = InviteStatus.pending;
      case 'denied':
        status = InviteStatus.decline;
      default:
        status = InviteStatus.pending;
    }

    return Guest(
      uid: map["user_id"],
      firstName: map["first_name"],
      lastName: map["last_name"],
      status: status,
    );
  }

  String get avatarReq {
    String requestUrl = "$goRepoDomain/image?id=$uid";

    return requestUrl;
  }

  String get fullName {
    return "$firstName $lastName";
  }
}
