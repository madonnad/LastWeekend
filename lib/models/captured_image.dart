import 'dart:async';

import 'package:camera/camera.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:uuid/uuid.dart';

class CapturedImage {
  XFile imageXFile;
  String uuid;
  DateTime capturedAt;
  String? albumID;
  String? caption;
  bool addToRecap;
  UploadType type;
  StreamController<double> uploadStatusController =
      StreamController<double>.broadcast();

  CapturedImage({
    required this.imageXFile,
    required this.type,
    required this.capturedAt,
    String? uuid,
    this.albumID,
    this.addToRecap = false,
    this.caption,
  }) : uuid = uuid ?? const Uuid().v4();

  Stream<double> get uploadStatus => uploadStatusController.stream;

  CapturedImage setAddToRecap(bool newValue) {
    return CapturedImage(
      imageXFile: imageXFile,
      type: type,
      capturedAt: capturedAt,
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
      "uuid": uuid,
      "image_xfile": imageXFile.path,
      "captured_at": capturedAt.toUtc().toIso8601String(),
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
      uuid: json['uuid'],
      imageXFile: XFile(json['image_xfile']),
      capturedAt: DateTime.parse(json['captured_at']),
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
      "uuid": uuid,
      "captured_at": capturedAt.toUtc().toIso8601String(),
      "album_id": albumID ?? '',
      "caption": caption,
      "upload_type": typeString,
    };
  }

  // @override
  // List<Object?> get props => [imageXFile, album, caption, addToRecap];
}
