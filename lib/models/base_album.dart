import 'package:shared_photo/utils/api_variables.dart';
import 'package:timeago/timeago.dart' as timeago;

enum Visibility { private, public, friends }

enum AlbumPhases { invite, unlock, lock, reveal }

class BaseAlbum {
  String albumID;
  String albumCoverID;
  String ownerID;
  String ownerFirst;
  String ownerLast;
  AlbumPhases phase;
  DateTime unlockDatetime;
  DateTime lockDatetime;
  DateTime revealDatetime;
  Visibility visibility;

  BaseAlbum({
    required this.albumID,
    required this.albumCoverID,
    required this.ownerID,
    required this.ownerFirst,
    required this.ownerLast,
    required this.phase,
    required this.unlockDatetime,
    required this.lockDatetime,
    required this.revealDatetime,
    required this.visibility,
  });

  String get albumCoverImageUrl {
    String requestUrl = "$goRepoDomain/image?id=$albumCoverID";

    return requestUrl;
  }

  String get ownerProfileImageURl {
    String requestUrl = "$goRepoDomain/image?id=$ownerID";

    return requestUrl;
  }

  String get fullName {
    String fullName = "$ownerFirst $ownerLast";

    return fullName;
  }

  String get timeSince {
    return timeago.format(revealDatetime);
  }

  factory BaseAlbum.fromMap(Map<String, dynamic> map) {
    Visibility visibility;
    AlbumPhases phase;

    switch (map['phase']) {
      case 'invite':
        phase = AlbumPhases.invite;
      case 'unlock':
        phase = AlbumPhases.unlock;
      case 'lock':
        phase = AlbumPhases.lock;
      case 'reveal':
        phase = AlbumPhases.reveal;
      default:
        phase = AlbumPhases.invite;
    }

    switch (map['visibility']) {
      case 'private':
        visibility = Visibility.private;
      case 'friends':
        visibility = Visibility.friends;
      case 'public':
        visibility = Visibility.public;
      default:
        visibility = Visibility.private;
    }
    return BaseAlbum(
      albumID: map['album_id'],
      albumCoverID: map['album_cover_id'],
      ownerID: map['album_owner'],
      ownerFirst: map['owner_first'],
      ownerLast: map['owner_last'],
      phase: phase,
      unlockDatetime: DateTime.parse(map['unlocked_at']),
      lockDatetime: DateTime.parse(map['locked_at']),
      revealDatetime: DateTime.parse(map['revealed_at']),
      visibility: visibility,
    );
  }
}
