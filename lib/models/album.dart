// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/utils/api_variables.dart';

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

  Album({
    required this.albumId,
    required this.albumName,
    required this.albumOwner,
    this.creationDateTime,
    required this.lockDateTime,
    required this.unlockDateTime,
    required this.revealDateTime,
    this.albumCoverId = '',
    this.images = const [],
    this.albumCoverUrl,
  });

  @override
  String toString() {
    return 'Album(albumId: $albumId, albumName: $albumName, albumOwner: $albumOwner, images: $images, creationDateTime: $creationDateTime, lockDateTime: $lockDateTime)';
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
    dynamic? jsonImages = map['images'];

    if (jsonImages != null) {
      for (var item in jsonImages[0]) {
        Image image = Image.fromMap(item);

        images.add(image);
      }
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
    );
  }

  String get coverReq {
    String requestUrl = "$goRepoDomain/image?id=$albumCoverId";

    return requestUrl;
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);
}
