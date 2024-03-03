// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shared_photo/models/guest.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/utils/api_variables.dart';

enum Visibility { private, public, friends }

enum AlbumPhases { invite, unlock, lock, reveal }

class Album {
  String albumId;
  String albumName;
  String albumOwner;
  String ownerFirst;
  String ownerLast;
  String albumCoverId;
  Map<String, Image> imageMap;
  List<Guest> guests;
  String? creationDateTime;
  String lockDateTime;
  String unlockDateTime;
  String revealDateTime;
  String? albumCoverUrl;
  Visibility visibility;
  AlbumPhases phase;

  Album({
    required this.albumId,
    required this.albumName,
    required this.albumOwner,
    required this.ownerFirst,
    required this.ownerLast,
    this.creationDateTime,
    required this.lockDateTime,
    required this.unlockDateTime,
    required this.revealDateTime,
    required this.visibility,
    required this.phase,
    this.albumCoverId = '',
    this.imageMap = const {},
    this.guests = const [],
    this.albumCoverUrl,
  });

  @override
  String toString() {
    return 'Album(albumId: $albumId, albumName: $albumName, albumOwner: $albumOwner,visibility: $visibility, images: $images, creationDateTime: $creationDateTime, lockDateTime: $lockDateTime)';
  }

  static final empty = Album(
    albumId: "",
    albumName: "",
    albumOwner: "",
    ownerFirst: "",
    ownerLast: "",
    lockDateTime: "",
    unlockDateTime: "",
    revealDateTime: "",
    visibility: Visibility.public,
    phase: AlbumPhases.invite,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'album_cover_id': albumCoverId,
      'album_name': albumName,
      'album_owner': albumOwner,
      'unlocked_at': unlockDateTime,
      'locked_at': lockDateTime,
      'revealed_at': revealDateTime,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    Map<String, Image> images = {};
    List<Guest> guests = [];
    Visibility visibility;
    AlbumPhases phase;
    dynamic jsonImages = map['images'];
    dynamic jsonGuests = map['invite_list'];

    if (jsonImages != null) {
      for (var item in jsonImages) {
        Image image = Image.fromMap(item);

        images.putIfAbsent(image.imageId, () => image);
      }
    }

    if (jsonGuests != null) {
      for (var item in jsonGuests) {
        Guest guest = Guest.fromMap(item);

        guests.add(guest);
      }
    }

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

    return Album(
      albumId: map['album_id'] as String,
      albumCoverId: map['album_cover_id'] as String,
      albumName: map['album_name'] as String,
      albumOwner: map['album_owner'] as String,
      ownerFirst: map['owner_first'],
      ownerLast: map['owner_last'],
      creationDateTime: map['created_at'],
      guests: guests,
      imageMap: images,
      lockDateTime: map['locked_at'],
      unlockDateTime: map['unlocked_at'],
      revealDateTime: map['revealed_at'],
      visibility: visibility,
      phase: phase,
    );
  }

  String get coverReq {
    String requestUrl = "$goRepoDomain/image?id=$albumCoverId";

    return requestUrl;
  }

  String get ownerImageURl {
    String requestUrl = "$goRepoDomain/image?id=$albumOwner";

    return requestUrl;
  }

  String get fullName {
    String fullName = "$ownerFirst $ownerLast";

    return fullName;
  }

  List<Image> get images {
    return imageMap.values.toList();
  }

  List<Image> get rankedImages {
    List<Image> rankedImages = List.from(images);
    rankedImages.sort((a, b) => b.upvotes.compareTo(a.upvotes));

    return rankedImages;
  }

  List<Image> get topThreeImages {
    List<Image> images = List.from(rankedImages);
    if (rankedImages.length > 3) {
      return images.getRange(0, 3).toList();
    } else if (rankedImages.isNotEmpty) {
      return rankedImages.getRange(0, images.length - 1).toList();
    } else {
      return [];
    }
  }

  List<Image> get remainingRankedImages {
    List<Image> images = List.from(rankedImages);
    if (rankedImages.length > 3) {
      images.removeRange(0, 3);
      return images;
    } else {
      return [];
    }
  }

  List<List<Image>> get imagesGroupedByGuest {
    Map<String, List<Image>> mapImages = {};
    List<List<Image>> listImages = [];

    for (var item in images) {
      if (!mapImages.containsKey(item.owner)) {
        mapImages[item.owner] = [];
      }
      if (mapImages[item.owner] != null) {
        mapImages[item.owner]!.add(item);
      }
    }

    mapImages.forEach((key, value) {
      value.sort((a, b) => b.upvotes.compareTo(a.upvotes));
    });

    mapImages.forEach((key, value) {
      listImages.add(value);
    });

    return listImages;
  }

  List<List<Image>> get imagesGroupedSortedByDate {
    Map<String, List<Image>> mapImages = {};
    List<List<Image>> listImages = [];

    for (var item in images) {
      if (!mapImages.containsKey(item.dateString)) {
        mapImages[item.dateString] = [];
      }
      if (mapImages[item.dateString] != null) {
        mapImages[item.dateString]!.add(item);
      }
    }

    mapImages.forEach((key, value) {
      value.sort((a, b) => a.uploadDateTime.compareTo(b.uploadDateTime));
    });

    mapImages.forEach((key, value) {
      listImages.add(value);
    });

    return listImages;
  }

  List<Guest> get sortedGuestsByInvite {
    List<Guest> unsortedGuests = List.from(guests);
    List<Guest> acceptedGuests = unsortedGuests
        .where((element) => element.status == InviteStatus.accept)
        .toList();
    List<Guest> pendingGuests = unsortedGuests
        .where((element) => element.status == InviteStatus.pending)
        .toList();

    List<Guest> sortedGuests = [];
    sortedGuests.addAll(acceptedGuests);
    sortedGuests.addAll(pendingGuests);
    return sortedGuests;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Album &&
          runtimeType == other.runtimeType &&
          albumId == other.albumId;

  @override
  int get hashCode => albumId.hashCode;
}
