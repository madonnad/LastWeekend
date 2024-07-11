import 'package:camera/camera.dart';
import 'package:shared_photo/models/photo.dart';

class CapturedImage {
  XFile imageXFile;
  String? albumID;
  String? caption;
  bool addToRecap;
  UploadType type;

  CapturedImage({
    required this.imageXFile,
    required this.type,
    this.albumID,
    this.addToRecap = false,
    this.caption,
  });

  CapturedImage setAddToRecap(bool newValue) {
    return CapturedImage(
      imageXFile: imageXFile,
      type: type,
      albumID: albumID,
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
      "image_xfile": imageXFile.path,
      "album_id": albumID ?? '',
      "caption": caption,
      "upload_type": typeString,
    };
  }

  static CapturedImage fromJson(Map<String, dynamic> json) {
    UploadType type = UploadType.snap;
    if (json['upload_type'] == 'forgot_shot') {
      type = UploadType.forgotShot;
    }

    return CapturedImage(
      imageXFile: XFile(json['image_xfile']),
      albumID: json['album_id'],
      caption: json['caption'],
      type: type,
    );
  }

  Map<String, dynamic> uploadJson() {
    String typeString = 'snap';

    if (type == UploadType.forgotShot) {
      typeString = 'forgot_shot';
    }

    return {
      "album_id": albumID ?? '',
      "caption": caption,
      "upload_type": typeString,
    };
  }

  // @override
  // List<Object?> get props => [imageXFile, album, caption, addToRecap];
}
