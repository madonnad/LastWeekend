import 'package:shared_photo/models/image.dart';

class ImageChange {
  String albumID;
  String imageID;
  Image image;

  ImageChange({
    required this.albumID,
    required this.imageID,
    required this.image,
  });
}
