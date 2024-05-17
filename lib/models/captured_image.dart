import 'package:camera/camera.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/photo.dart';

class CapturedImage {
  XFile imageXFile;
  Album? album;
  String? caption;
  bool addToRecap;
  UploadType type;

  CapturedImage({
    required this.imageXFile,
    required this.type,
    this.album,
    this.addToRecap = false,
    this.caption,
  });

  CapturedImage setAddToRecap(bool newValue) {
    return CapturedImage(
      imageXFile: imageXFile,
      type: type,
      album: album,
      caption: caption,
      addToRecap: newValue,
    );
  }

  Map<String, dynamic> toJson() {
    String typeString = 'snap';

    if (type == UploadType.forgotShot) {
      typeString = 'forgot_shot';
    }

    return {
      "album_id": album?.albumId ?? '',
      "caption": caption,
      "upload_type": typeString,
    };
  }

  // @override
  // List<Object?> get props => [imageXFile, album, caption, addToRecap];
}
