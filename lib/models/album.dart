// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:shared_photo/models/image.dart';

class Album {
  String albumId;
  String albumName;
  String albumOwner;
  List<Image> images;
  DateTime creationDateTime;
  DateTime lockDateTime;

  Album({
    required this.albumId,
    required this.albumName,
    required this.albumOwner,
    required this.creationDateTime,
    required this.lockDateTime,
    required this.images,
  });

  @override
  String toString() {
    return 'Album(albumId: $albumId, albumName: $albumName, albumOwner: $albumOwner, images: $images, creationDateTime: $creationDateTime, lockDateTime: $lockDateTime)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'album_id': albumId,
      'album_name': albumName,
      'album_owner': albumOwner,
      'images': images.map((x) => x.toMap()).toList(),
      'created_at': creationDateTime.millisecondsSinceEpoch,
      'locked_at': lockDateTime.millisecondsSinceEpoch,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      albumId: map['album_id'] as String,
      albumName: map['album_name'] as String,
      albumOwner: map['album_owner'] as String,
      images: [],
      creationDateTime: DateTime.parse(map['created_at']),
      lockDateTime: DateTime.parse(map['locked_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);
}

/* List<Image>.from(
        (map['images'] as List<int>).map<Image>(
          (x) => Image.fromMap(x as Map<String, dynamic>),
        ),
      ), */