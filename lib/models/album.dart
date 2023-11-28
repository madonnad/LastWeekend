// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
  List<Image> images;
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
    this.images = const [],
    this.guests = const [],
    this.albumCoverUrl,
  });

  @override
  String toString() {
    return 'Album(albumId: $albumId, albumName: $albumName, albumOwner: $albumOwner,visibility: $visibility, images: $images, creationDateTime: $creationDateTime, lockDateTime: $lockDateTime)';
  }

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
    List<Image> images = [];
    List<Guest> guests = [];
    Visibility visibility;
    AlbumPhases phase;
    dynamic jsonImages = map['images'];
    dynamic jsonGuests = map['invite_list'];

    if (jsonImages != null) {
      for (var item in jsonImages) {
        Image image = Image.fromMap(item);

        images.add(image);
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
      images: images,
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

  List<Image> get rankedImages {
    List<Image> rankedImages = List.from(images);
    rankedImages.sort((a, b) => b.upvotes.compareTo(a.upvotes));

    return rankedImages;
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
}
