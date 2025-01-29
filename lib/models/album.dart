import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:shared_photo/models/guest.dart';
import 'package:shared_photo/models/photo.dart';

enum AlbumVisibility {
  private("Private"),
  friends("Friends"),
  public("Public");

  final String description;
  const AlbumVisibility(this.description);
}

enum AlbumPhases { open, reveal }

class Album extends Equatable {
  final String albumId;
  final String albumName;
  final String albumOwner;
  final String ownerFirst;
  final String ownerLast;
  final String albumCoverId;
  final Map<String, Photo> imageMap;
  final Map<String, Guest> guestMap;
  final DateTime creationDateTime;
  final DateTime revealDateTime;
  final String? albumCoverUrl;
  final AlbumVisibility visibility;
  final AlbumPhases phase;

  const Album({
    required this.albumId,
    required this.albumName,
    required this.albumOwner,
    required this.ownerFirst,
    required this.ownerLast,
    required this.creationDateTime,
    required this.revealDateTime,
    required this.visibility,
    required this.phase,
    this.albumCoverId = '',
    this.imageMap = const {},
    this.guestMap = const {},
    this.albumCoverUrl,
  });

  @override
  String toString() {
    return 'Album(albumId: $albumId, albumName: $albumName, albumOwner: $albumOwner,visibility: $visibility, images: $images, creationDateTime: $creationDateTime, guests: $guests)';
  }

  static final empty = Album(
    albumId: "",
    albumName: "",
    albumOwner: "",
    ownerFirst: "",
    ownerLast: "",
    creationDateTime: DateTime.utc(1900),
    revealDateTime: DateTime.utc(1900),
    visibility: AlbumVisibility.public,
    phase: AlbumPhases.open,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'album_cover_id': albumCoverId,
      'album_name': albumName,
      'album_owner': albumOwner,
      'revealed_at': revealDateTime,
    };
  }

  factory Album.from(Album album) {
    return Album(
      albumId: album.albumId,
      albumName: album.albumName,
      albumOwner: album.albumOwner,
      ownerFirst: album.ownerFirst,
      ownerLast: album.ownerLast,
      albumCoverId: album.albumCoverId,
      imageMap: album.imageMap,
      guestMap: album.guestMap,
      creationDateTime: album.creationDateTime,
      revealDateTime: album.revealDateTime,
      albumCoverUrl: album.albumCoverUrl,
      visibility: album.visibility,
      phase: album.phase,
    );
  }

  Album copyWith({
    Map<String, Photo>? imageMap,
    AlbumVisibility? visibility,
  }) {
    return Album(
      albumId: albumId,
      albumName: albumName,
      albumOwner: albumOwner,
      ownerFirst: ownerFirst,
      ownerLast: ownerLast,
      creationDateTime: creationDateTime,
      revealDateTime: revealDateTime,
      visibility: visibility ?? this.visibility,
      phase: phase,
      imageMap: imageMap ?? this.imageMap,
      guestMap: guestMap,
      albumCoverId: albumCoverId,
    );
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    Map<String, Photo> images = {};
    Map<String, Guest> guests = {};
    AlbumVisibility visibility;
    AlbumPhases phase;
    dynamic jsonImages = map['images'];
    dynamic jsonGuests = map['invite_list'];

    if (jsonImages != null) {
      for (var item in jsonImages) {
        Photo image = Photo.fromMap(item);

        images.putIfAbsent(image.imageId, () => image);
      }
    }

    if (jsonGuests != null) {
      for (var item in jsonGuests) {
        Guest guest = Guest.fromMap(item);

        guests[guest.uid] = guest;
      }
    }

    switch (map['phase']) {
      case 'invite':
        phase = AlbumPhases.open;
      case 'unlock':
        phase = AlbumPhases.open;
      case 'lock':
        phase = AlbumPhases.open;
      case 'reveal':
        phase = AlbumPhases.reveal;
      default:
        phase = AlbumPhases.open;
    }

    switch (map['visibility']) {
      case 'private':
        visibility = AlbumVisibility.private;
      case 'friends':
        visibility = AlbumVisibility.friends;
      case 'public':
        visibility = AlbumVisibility.public;
      default:
        visibility = AlbumVisibility.private;
    }

    List<int> bytes = map['album_name'].toString().codeUnits;
    String albumName = utf8.decode(bytes);

    return Album(
      albumId: map['album_id'] as String,
      albumCoverId: map['album_cover_id'] as String,
      albumName: albumName,
      albumOwner: map['album_owner'] as String,
      ownerFirst: map['owner_first'],
      ownerLast: map['owner_last'],
      creationDateTime: DateTime.parse(map['created_at']),
      guestMap: guests,
      imageMap: images,
      revealDateTime: DateTime.parse(map['revealed_at']),
      visibility: visibility,
      phase: phase,
    );
  }

  String get coverReq {
    String requestUrl = "${dotenv.env['URL']}/image?id=$albumCoverId";

    return requestUrl;
  }

  String get coverReq1080 {
    String requestUrl = "${dotenv.env['URL']}/image?id=${albumCoverId}_1080";

    return requestUrl;
  }

  String get coverReq540 {
    String requestUrl = "${dotenv.env['URL']}/image?id=${albumCoverId}_540";

    return requestUrl;
  }

  String get ownerImageURl {
    String requestUrl = "${dotenv.env['URL']}/image?id=$albumOwner";

    return requestUrl;
  }

  String get fullName {
    String fullName = "$ownerFirst $ownerLast";

    return fullName;
  }

  List<Guest> get guests => guestMap.values.toList();

  String get timeSince {
    return "${timeago.format(revealDateTime, locale: 'en_short')} ago";
  }

  List<Photo> get images {
    return imageMap.values.toList();
  }

  List<Photo> get rankedImages {
    List<Photo> rankedImages = List.from(images);
    rankedImages.sort((a, b) {
      if (a.upvotes == b.upvotes) {
        return a.capturedDatetime.compareTo(b.capturedDatetime);
      } else {
        return b.upvotes.compareTo(a.upvotes);
      }
    });

    return rankedImages;
  }

  List<Photo> get topThreeImages {
    List<Photo> images = List.from(rankedImages);
    if (rankedImages.length > 3) {
      return images.getRange(0, 3).toList();
    } else if (rankedImages.isNotEmpty) {
      return rankedImages.getRange(0, images.length - 1).toList();
    } else {
      return [];
    }
  }

  List<Photo> get remainingRankedImages {
    List<Photo> images = List.from(rankedImages);
    if (rankedImages.length > 3) {
      images.removeRange(0, 3);
      return images;
    } else {
      return [];
    }
  }

  List<List<Photo>> get imagesGroupedByGuest {
    Map<String, List<Photo>> mapImages = {};
    List<List<Photo>> listImages = [];

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

  Map<String, int> get imageCountByGuestMap {
    Map<String, int> countMap = {};
    for (Photo item in images) {
      if (countMap.containsKey(item.owner)) {
        countMap[item.owner] = countMap[item.owner]! + 1;
      } else {
        countMap[item.owner] = 1;
      }
    }
    return countMap;
  }

  Map<String, List<List<Photo>>> get imagesGroupByGuestMap {
    Map<String, Map<String, List<Photo>>> mapImages = {};
    Map<String, List<List<Photo>>> dateSortedMap = {};

    for (var item in images) {
      if (mapImages[item.owner] == null) {
        mapImages[item.owner] = {
          item.dateString: [item]
        };
      } else {
        if (mapImages[item.owner]?[item.dateString] != null) {
          mapImages[item.owner]![item.dateString]!.add(item);
        } else {
          mapImages[item.owner]?[item.dateString] = [item];
        }
      }
    }

    mapImages.forEach((userID, dateMap) {
      dateMap.forEach((dateString, imageList) {
        imageList
            .sort((a, b) => a.capturedDatetime.compareTo(b.capturedDatetime));
      });
      dateSortedMap[userID] = List.from(dateMap.values);
    });

    return dateSortedMap;
  }

  List<List<Photo>> get imagesGroupedSortedByDate {
    Map<String, List<Photo>> mapImages = {};
    List<List<Photo>> listImages = [];

    for (var item in images) {
      if (!mapImages.containsKey(item.dateString)) {
        mapImages[item.dateString] = [];
      }
      if (mapImages[item.dateString] != null) {
        mapImages[item.dateString]!.add(item);
      }
    }

    mapImages.forEach((key, value) {
      value.sort((a, b) => b.capturedDatetime.compareTo(a.capturedDatetime));
    });

    mapImages.forEach((key, value) {
      listImages.add(value);
    });

    listImages
        .sort((a, b) => b[0].capturedDatetime.compareTo(a[0].capturedDatetime));

    return listImages;
  }

  List<Guest> get sortedGuestsByInvite {
    List<Guest> unsortedGuests = List.from(guestMap.values);
    List<Guest> acceptedGuests = unsortedGuests
        .where((element) => element.status == RequestStatus.accepted)
        .toList();
    List<Guest> pendingGuests = unsortedGuests
        .where((element) => element.status == RequestStatus.pending)
        .toList();
    List<Guest> deniedGuests = unsortedGuests
        .where((element) => element.status == RequestStatus.denied)
        .toList();

    List<Guest> sortedGuests = [];
    sortedGuests.addAll(acceptedGuests);
    sortedGuests.addAll(pendingGuests);
    sortedGuests.addAll(deniedGuests);
    return sortedGuests;
  }

  String get revealDateTimeFormatter {
    String dateString;
    if (revealDateTime.year != DateTime.now().year) {
      dateString =
          DateFormat("EEE MMM d, ''yy @ h:mm aaa").format(revealDateTime);
      return dateString;
    }
    return dateString =
        DateFormat("EEE MMM d @ h:mm aaa").format(revealDateTime);
  }

  String get durationDateFormatter {
    DateTime createdDay = creationDateTime.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
    DateTime revealDay = revealDateTime.copyWith(
        hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

    if (revealDay == createdDay) {
      String dateString;
      dateString = DateFormat("MMM d, yyyy").format(revealDateTime);
      return dateString;
    } else {
      String creationString;
      String revealString;
      creationString = DateFormat("MMM d, yyyy").format(creationDateTime);
      revealString = DateFormat("MMM d, yyyy").format(revealDateTime);
      return "$creationString - $revealString";
    }
  }

  @override
  List<Object?> get props => [
        albumId,
        guestMap,
        imageMap.hashCode,
        albumOwner,
        visibility,
      ];
}
