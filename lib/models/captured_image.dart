import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';

class CapturedImage extends Equatable {
  final XFile imageXFile;
  final Album? album;
  String? caption;
  bool addToRecap;

  CapturedImage({
    required this.imageXFile,
    this.album,
    this.addToRecap = false,
    this.caption,
  });

  CapturedImage setAddToRecap(bool newValue) {
    return CapturedImage(
      imageXFile: imageXFile,
      album: album,
      caption: caption,
      addToRecap: newValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "album_id": album?.albumId ?? '',
      "caption": caption,
    };
  }

  @override
  List<Object?> get props => [imageXFile, album, caption, addToRecap];
}
