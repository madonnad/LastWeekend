// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/utils/api_variables.dart';

enum Visibility { private, public, friends }

class Album {
  String albumId;
  String albumName;
  String albumOwner;
  String albumCoverId;
  List<Image> images;
  String? creationDateTime;
  String lockDateTime;
  String unlockDateTime;
  String revealDateTime;
  String? albumCoverUrl;
  Visibility visibility;

  Album({
    required this.albumId,
    required this.albumName,
    required this.albumOwner,
    this.creationDateTime,
    required this.lockDateTime,
    required this.unlockDateTime,
    required this.revealDateTime,
    required this.visibility,
    this.albumCoverId = '',
    this.images = const [],
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
    Visibility visibility;
    dynamic jsonImages = map['images'];

    if (jsonImages != null) {
      for (var item in jsonImages) {
        Image image = Image.fromMap(item);

        images.add(image);
      }
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
      creationDateTime: map['created_at'],
      images: images,
      lockDateTime: map['locked_at'],
      unlockDateTime: map['unlocked_at'],
      revealDateTime: map['revealed_at'],
      visibility: visibility,
    );
  }

  String get coverReq {
    String requestUrl = "$goRepoDomain/image?id=$albumCoverId";

    return requestUrl;
  }

  static final empty = Album(
      albumId: "",
      albumName: "",
      albumOwner: "",
      lockDateTime: "",
      unlockDateTime: "",
      revealDateTime: "",
      visibility: Visibility.public);
}
