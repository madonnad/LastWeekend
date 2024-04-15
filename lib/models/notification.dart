import 'package:equatable/equatable.dart';
import 'package:shared_photo/utils/api_variables.dart';
import 'package:shared_photo/utils/time_until.dart';
import 'package:timeago/timeago.dart' as timeago;

enum EngageType { liked, upvoted }

enum EngageOperation { add, remove }

enum NotificationType { generic, friendRequest, albumInvite }

enum RequestStatus {
  pending(1),
  accepted(2),
  denied(3);

  const RequestStatus(this.val);
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

  Notification copyWith({
    String? notificationID,
    DateTime? receivedDateTime,
    String? notificationMediaID,
    bool? notificationSeen,
  });

  String get imageReq {
    String requestUrl = "$goRepoDomain/image?id=$notificationMediaID";

    return requestUrl;
  }

  String get timeAgoString {
    return timeago.format(receivedDateTime);
  }
}

class AlbumInviteNotification extends Notification {
  final String albumID;
  final String albumName;
  final String albumOwner;
  final String ownerFirst;
  final String ownerLast;
  final String guestID;
  final String guestFirst;
  final String guestLast;
  final RequestStatus status;
  final bool responseSeen;
  final DateTime unlockedAt;
  const AlbumInviteNotification({
    required super.notificationID,
    required super.receivedDateTime,
    required super.notificationMediaID,
    required super.notificationSeen,
    required this.albumID,
    required this.albumName,
    required this.albumOwner,
    required this.ownerFirst,
    required this.ownerLast,
    required this.guestID,
    required this.guestFirst,
    required this.guestLast,
    required this.responseSeen,
    required this.status,
    required this.unlockedAt,
  });

  String get ownerURL => "$goRepoDomain/image?id=$albumOwner";
  String get guestURL => "$goRepoDomain/image?id=$guestID";
  String get timeUntil => TimeUntil.format(unlockedAt);
  String get timeReceived => timeago.format(receivedDateTime,
      locale: "en_short", clock: DateTime.now().toUtc());

  factory AlbumInviteNotification.fromMap(Map<String, dynamic> map) {
    RequestStatus status = RequestStatus.pending;

    switch (map['status']) {
      case 'accepted':
        status = RequestStatus.accepted;
        break;
      case 'denied':
        status = RequestStatus.denied;
        break;
    }

    return AlbumInviteNotification(
      notificationID: map['request_id'],
      receivedDateTime: DateTime.parse(map['received_at']),
      notificationMediaID: map['album_cover_id'],
      notificationSeen: map['invite_seen'],
      albumID: map['album_id'],
      albumName: map['album_name'],
      albumOwner: map['album_owner'],
      ownerFirst: map['owner_first'],
      ownerLast: map['owner_last'],
      guestID: map['guest_id'],
      guestFirst: map['guest_first'],
      guestLast: map['guest_last'],
      status: status,
      responseSeen: map['response_seen'],
      unlockedAt: DateTime.parse(map['unlocked_at']),
    );
  }

  @override
  AlbumInviteNotification copyWith({
    String? notificationID,
    DateTime? receivedDateTime,
    String? notificationMediaID,
    RequestStatus? status,
    bool? notificationSeen,
  }) {
    return AlbumInviteNotification(
      notificationID: notificationID ?? this.notificationID,
      receivedDateTime: receivedDateTime ?? this.receivedDateTime,
      notificationMediaID: notificationMediaID ?? this.notificationMediaID,
      notificationSeen: notificationSeen ?? this.notificationSeen,
      status: status ?? this.status,
      albumID: albumID,
      albumName: albumName,
      albumOwner: albumOwner,
      ownerFirst: ownerFirst,
      ownerLast: ownerLast,
      guestID: guestID,
      guestFirst: guestFirst,
      guestLast: guestLast,
      responseSeen: responseSeen,
      unlockedAt: unlockedAt,
    );
  }

  @override
  List<Object?> get props => [status, notificationSeen];
}

class FriendRequestNotification extends Notification {
  final String senderID;
  final String receiverID;
  final String firstName;
  final String lastName;
  final RequestStatus status;
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
    RequestStatus status = RequestStatus.pending;

    if (map['status'] == 'accepted') {
      status = RequestStatus.accepted;
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
    String? notificationID,
    String? notificationMediaID,
    bool? notificationSeen,
    DateTime? receivedDateTime,
    RequestStatus? status,
  }) {
    return FriendRequestNotification(
      notificationID: notificationID ?? this.notificationID,
      receivedDateTime: receivedDateTime ?? this.receivedDateTime,
      notificationMediaID: notificationMediaID ?? this.notificationMediaID,
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

class EngagementNotification extends Notification {
  final String albumID;
  final String albumName;
  final String receiverID;
  final String notifierID;
  final String notifierFirst;
  final String notifierLast;
  final EngageType notificationType;
  final EngageOperation operation;
  final int newCount;

  const EngagementNotification({
    required super.notificationID,
    required super.receivedDateTime,
    required super.notificationMediaID,
    required super.notificationSeen,
    required this.albumID,
    required this.albumName,
    required this.receiverID,
    required this.notifierID,
    required this.notifierFirst,
    required this.notifierLast,
    required this.notificationType,
    required this.operation,
    required this.newCount,
  });

  factory EngagementNotification.fromMap(
      Map<String, dynamic> map, String operation) {
    EngageType type = EngageType.liked;
    EngageOperation op =
        operation == 'ADD' ? EngageOperation.add : EngageOperation.remove;

    if (map['notification_type'] == 'like') {
      type = EngageType.liked;
    }
    if (map['notification_type'] == 'upvote') {
      type = EngageType.upvoted;
    }

    return EngagementNotification(
      notificationID: map['notification_id'],
      receivedDateTime: DateTime.parse(map['received_at']),
      notificationMediaID: map['image_id'],
      notificationSeen: map['notification_seen'],
      albumID: map['album_id'],
      albumName: map['album_name'],
      receiverID: map['receiver_id'],
      notifierID: map['notifier_id'],
      notifierFirst: map['notifier_first'],
      notifierLast: map['notifier_last'],
      notificationType: type,
      operation: op,
      newCount: map['new_count'],
    );
  }

  @override
  EngagementNotification copyWith({
    String? notificationID,
    String? notificationMediaID,
    bool? notificationSeen,
    DateTime? receivedDateTime,
    EngageType? notificationType,
    int? newCount,
  }) {
    return EngagementNotification(
      notificationID: notificationID ?? this.notificationID,
      receivedDateTime: receivedDateTime ?? this.receivedDateTime,
      notificationMediaID: notificationMediaID ?? this.notificationMediaID,
      notificationSeen: notificationSeen ?? this.notificationSeen,
      albumID: albumID,
      albumName: albumName,
      receiverID: receiverID,
      notifierID: notifierID,
      notifierFirst: notifierFirst,
      notifierLast: notifierLast,
      notificationType: notificationType ?? this.notificationType,
      operation: operation,
      newCount: newCount ?? this.newCount,
    );
  }

  @override
  List<Object?> get props => [
        notificationID,
        receivedDateTime,
        notificationMediaID,
        notificationSeen,
        notificationType,
        newCount,
      ];
}
