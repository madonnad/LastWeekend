import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/notification.dart';

class Guest {
  String uid;
  String firstName;
  String lastName;
  RequestStatus status;

  Guest({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.status,
  });

  factory Guest.fromMap(Map<String, dynamic> map) {
    late RequestStatus status;
    switch (map['status']) {
      case 'accepted':
        status = RequestStatus.accepted;
      case 'pending':
        status = RequestStatus.pending;
      case 'denied':
        status = RequestStatus.denied;
      case 'abandoned':
        status = RequestStatus.abandoned;
      default:
        status = RequestStatus.pending;
    }

    return Guest(
      uid: map["user_id"],
      firstName: map["first_name"],
      lastName: map["last_name"],
      status: status,
    );
  }

  String get avatarReq {
    String requestUrl = "${dotenv.env['URL']}/image?id=$uid";

    return requestUrl;
  }

  String get avatarReq540 {
    String requestUrl = "${dotenv.env['URL']}/image?id=${uid}_540";

    return requestUrl;
  }

  String get fullName {
    return "$firstName $lastName";
  }
}
