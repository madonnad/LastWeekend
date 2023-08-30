import 'package:shared_photo/components/profile_comp/notification_comp/album_invite_notification_comp.dart';

enum GenericNotificationType { likedPhoto, upvotePhoto, imageComment }

abstract class Notification {
  final DateTime receivedDateTime;
  final String notifierID;
  final String notifierName;
  final String notificationMediaID;
  String? notificationMediaURL;
  final bool notificationSeen;

  Notification({
    required this.receivedDateTime,
    required this.notifierID,
    required this.notifierName,
    required this.notificationMediaID,
    required this.notificationSeen,
    this.notificationMediaURL,
  });

  String get formattedDateTime {
    String formattedDateTime;

    final timeDiff = DateTime.now().difference(receivedDateTime).inSeconds;
    int modTimeDiff = timeDiff ~/ 60;

    if (modTimeDiff < 60) {
      formattedDateTime = '$modTimeDiff min ago';
    } else if (modTimeDiff > 60 && modTimeDiff < 86400) {
      modTimeDiff = timeDiff ~/ 3600;
      if (modTimeDiff == 1) {
        formattedDateTime = '1 hour ago';
      } else {
        formattedDateTime = '$modTimeDiff hours ago';
      }
    } else {
      modTimeDiff = timeDiff ~/ 86400;
      if (modTimeDiff == 1) {
        formattedDateTime = '1 day ago';
      } else {
        formattedDateTime = '$modTimeDiff day ago';
      }
    }
    return formattedDateTime;
  }
}

class AlbumInviteNotification extends Notification {
  final String albumName;
  AlbumInviteNotification({
    required super.receivedDateTime,
    required super.notifierID,
    required super.notifierName,
    required super.notificationMediaID,
    required super.notificationSeen,
    required this.albumName,
    super.notificationMediaURL,
  });

  factory AlbumInviteNotification.fromMap(Map<String, dynamic> map) {
    return AlbumInviteNotification(
      receivedDateTime: DateTime.parse(map['invited_at']),
      notifierID: map['album_owner'].toString(),
      notifierName: '${map['first_name']} ${map['last_name']}',
      notificationMediaID: map['album_cover_id'],
      notificationSeen: map['invite_seen'],
      albumName: map['album_name'],
    );
  }
}

class FriendRequestNotification extends Notification {
  FriendRequestNotification({
    required super.receivedDateTime,
    required super.notifierID,
    required super.notifierName,
    required super.notificationMediaID,
    required super.notificationSeen,
    super.notificationMediaURL,
  });

  factory FriendRequestNotification.fromMap(Map<String, dynamic> map) {
    return FriendRequestNotification(
      receivedDateTime: DateTime.parse(map['requested_at']),
      notifierID: map['sender_id'].toString(),
      notifierName: '${map['first_name']} ${map['last_name']}',
      notificationMediaID: map['avatar'] ?? '',
      notificationSeen: map['invite_seen'],
    );
  }
}

class GenericNotification extends Notification {
  GenericNotificationType notificationType;

  GenericNotification({
    required super.receivedDateTime,
    required super.notifierID,
    required super.notifierName,
    required super.notificationMediaID,
    required super.notificationSeen,
    required this.notificationType,
    super.notificationMediaURL,
  });
}
