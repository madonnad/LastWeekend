import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/utils/api_variables.dart';

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
    String requestUrl = "$goRepoDomain/image?id=$uid";

    return requestUrl;
  }

  String get fullName {
    return "$firstName $lastName";
  }
}
