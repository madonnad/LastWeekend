// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}
