import 'package:shared_photo/utils/api_variables.dart';

class BaseImage {
  String imageID;
  String owner;
  String firstName;
  String lastName;
  String imageCaption;
  DateTime uploadDateTime;
  int likes;
  int upvotes;

  BaseImage({
    required this.imageID,
    required this.owner,
    required this.firstName,
    required this.lastName,
    required this.imageCaption,
    required this.uploadDateTime,
    required this.likes,
    required this.upvotes,
  });

  String get imageURL => "$goRepoDomain/image?id=$imageID";

  factory BaseImage.fromMap(Map<String, dynamic> map) {
    return BaseImage(
      imageID: map['imageId'],
      owner: map['owner'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      imageCaption: map['imageCaption'],
      uploadDateTime: DateTime.parse(map['uploadDateTime']),
      likes: map['likes'],
      upvotes: map['upvotes'],
    );
  }
}
