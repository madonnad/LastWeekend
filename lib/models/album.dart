import 'package:shared_photo/models/photo.dart';

class Album {
  String albumUrl;
  String albumName;
  String albumOwner;
  String? albumCoverUrl;
  List<Photo>? photos;
  DateTime creationDateTime;
  DateTime lockDateTime;

  Album({
    required this.albumUrl,
    required this.albumName,
    required this.albumOwner,
    required this.creationDateTime,
    required this.lockDateTime,
  });
}
