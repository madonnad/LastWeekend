import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comment {
  String id;
  String imageID;
  String userID;
  String firstName;
  String lastName;
  String comment;
  DateTime createdAt;
  DateTime? updatedAt;
  bool seen;

  Comment({
    required this.id,
    required this.imageID,
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
    required this.seen,
  });

  // Create a Comment.fromCommentNotification factory constructor

  factory Comment.fromCommentNotification(CommentNotification notification) {
    return Comment(
      id: notification.notificationID,
      imageID: notification.notificationMediaID,
      userID: notification.notifierID,
      firstName: notification.notifierFirst,
      lastName: notification.notifierLast,
      comment: notification.comment,
      createdAt: notification.receivedDateTime,
      updatedAt: notification.updatedDateTime,
      seen: notification.notificationSeen,
    );
  }

  factory Comment.fromJson(Map<String, dynamic> map) {
    List<int> bytes = map['comment'].toString().codeUnits;
    String comment = utf8.decode(bytes);
    return Comment(
      id: map['id'],
      imageID: map['image_id'],
      userID: map['user_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      comment: comment,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      seen: map['seen'] ?? false,
    );
  }

  String get shortTime => timeago.format(createdAt, locale: 'en_short');

  String get avatarReq {
    String requestUrl = "${dotenv.env['URL']}/image?id=$userID";

    return requestUrl;
  }

  String get avatarReq540 {
    String requestUrl = "${dotenv.env['URL']}/image?id=${userID}_540";

    return requestUrl;
  }

  String get fullName {
    return '$firstName $lastName';
  }
}
