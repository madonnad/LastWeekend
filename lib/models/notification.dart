import 'package:equatable/equatable.dart';
import 'package:shared_photo/utils/api_variables.dart';

enum GenericNotificationType { likedPhoto, upvotePhoto, imageComment }

enum NotificationType { generic, friendRequest, albumInvite }

enum FriendRequestStatus {
  pending(1),
  accepted(2),
  decline(3);

  const FriendRequestStatus(this.val);
  final int val;
}

abstract class Notification extends Equatable {
  final String notificationID;
  final DateTime receivedDateTime;
  final String notificationMediaID;
  final bool notificationSeen;

  const Notification({
    required this.notificationID,
    required this.receivedDateTime,
    required this.notificationMediaID,
    required this.notificationSeen,
  });

  String get imageReq {
    String requestUrl = "$goRepoDomain/image?id=$notificationMediaID";

    return requestUrl;
  }

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
  final String albumID;
  final String albumName;
  final String albumOwner;
  final String ownerName;
  const AlbumInviteNotification({
    required super.notificationID,
    required super.receivedDateTime,
    required super.notificationMediaID,
    required super.notificationSeen,
    required this.albumID,
    required this.albumName,
    required this.albumOwner,
    required this.ownerName,
  });

  factory AlbumInviteNotification.fromMap(Map<String, dynamic> map) {
    return AlbumInviteNotification(
      notificationID: map['album_id'],
      receivedDateTime: DateTime.parse(map['received_at']),
      notificationMediaID: map['album_cover_id'],
      notificationSeen: map['request_seen'],
      albumID: map['album_id'],
      albumName: map['album_name'],
      albumOwner: map['album_owner'],
      ownerName: '${map['owner_first']} ${map['owner_last']}',
    );
  }

  @override
  List<Object?> get props => [];
}

class FriendRequestNotification extends Notification {
  final String senderID;
  final String receiverID;
  final String firstName;
  final String lastName;
  final FriendRequestStatus status;
  const FriendRequestNotification({
    required super.notificationID,
    required super.receivedDateTime,
    required super.notificationMediaID,
    required super.notificationSeen,
    required this.senderID,
    required this.receiverID,
    required this.firstName,
    required this.lastName,
    required this.status,
  });

  String get fullName => '$firstName $lastName';

  String get senderReq => "$goRepoDomain/image?id=$senderID";
  String get receiverReq => "$goRepoDomain/image?id=$receiverID";

  factory FriendRequestNotification.fromMap(Map<String, dynamic> map) {
    FriendRequestStatus status = FriendRequestStatus.pending;

    if (map['status'] == 'accepted') {
      status = FriendRequestStatus.accepted;
    }

    return FriendRequestNotification(
      notificationID: map['request_id'],
      receivedDateTime: DateTime.parse(map['received_at']),
      notificationSeen: map['request_seen'] as bool,
      senderID: map['sender_id'],
      receiverID: map['receiver_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      notificationMediaID: map['sender_id'],
      status: status,
    );
  }

  FriendRequestNotification copyWith({
    FriendRequestStatus? status,
    bool? notificationSeen,
  }) {
    return FriendRequestNotification(
      notificationID: notificationID,
      receivedDateTime: receivedDateTime,
      notificationMediaID: notificationMediaID,
      notificationSeen: notificationSeen ?? this.notificationSeen,
      senderID: senderID,
      receiverID: receiverID,
      firstName: firstName,
      lastName: lastName,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, notificationSeen];
}

class SummaryNotification extends Notification {
  final String notificationType;
  final String nameOne;
  final String? nameTwo;
  final String albumName;
  final String albumID;
  final int typeTotal;

  const SummaryNotification({
    required super.notificationID,
    required super.notificationMediaID,
    required super.receivedDateTime,
    required super.notificationSeen,
    required this.notificationType,
    required this.nameOne,
    required this.nameTwo,
    required this.albumName,
    required this.albumID,
    required this.typeTotal,
  });

  factory SummaryNotification.fromMap(Map<String, dynamic> map) {
    return SummaryNotification(
      notificationID: map['album_id'],
      notificationMediaID: map['album_cover_id'],
      receivedDateTime: DateTime.parse(map['received_at']),
      notificationSeen: map['request_seen'],
      notificationType: map['notification_type'],
      nameOne: map['name_one'],
      nameTwo: map['name_two'] ?? '',
      albumID: map['album_id'],
      albumName: map['album_name'],
      typeTotal: map['album_type_total'],
    );
  }

  @override
  List<Object?> get props => [];
}

class GenericNotification extends Notification {
  final String notifierID;
  final String notifierName;
  final String albumID;
  final String albumName;
  final GenericNotificationType notificationType;

  const GenericNotification({
    required super.notificationID,
    required super.receivedDateTime,
    required super.notificationMediaID,
    required super.notificationSeen,
    required this.notifierID,
    required this.notifierName,
    required this.albumID,
    required this.albumName,
    required this.notificationType,
  });

  factory GenericNotification.fromMap(Map<String, dynamic> map) {
    late GenericNotificationType notificationType;

    switch (map['notification_type']) {
      case 'upvote':
        notificationType = GenericNotificationType.upvotePhoto;
      case 'liked':
        notificationType = GenericNotificationType.likedPhoto;
    }

    return GenericNotification(
      notificationID: '',
      receivedDateTime: DateTime.parse(map['received_at']),
      notificationMediaID: map['media_id'],
      notifierID: map['notifier_id'],
      notifierName: map['notifier_name'],
      albumID: map['album_id'],
      albumName: map['album_name'],
      notificationSeen: map['notification_seen'],
      notificationType: notificationType,
    );
  }
  @override
  List<Object?> get props => [];
}
