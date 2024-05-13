import 'package:shared_photo/models/photo.dart';

class ImageChange {
  String albumID;
  String imageID;
  Photo image;

  ImageChange({
    required this.albumID,
    required this.imageID,
    required this.image,
  });
}
