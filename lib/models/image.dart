import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/engager.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Image {
  String imageId;
  String owner;
  String firstName;
  String lastName;
  String imageCaption;
  DateTime uploadDateTime;
  int likes;
  int upvotes;
  bool userLiked;
  bool userUpvoted;
  Map<String, Comment> commentMap;
  List<Engager> likesUID;
  List<Engager> upvotesUID;

  Image({
    required this.imageId,
    required this.owner,
    required this.firstName,
    required this.lastName,
    required this.uploadDateTime,
    required this.imageCaption,
    required this.likes,
    required this.upvotes,
    required this.userLiked,
    required this.userUpvoted,
    required this.commentMap,
    required this.likesUID,
    required this.upvotesUID,
  });

  @override
  String toString() {
    return 'Image(imageId: $imageId, owner: $owner, imageCaption: $imageCaption, uploadDateTime: $uploadDateTime)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image_id': imageId,
      'image_owner': owner,
      'caption': imageCaption,
    };
  }

  factory Image.fromMap(Map<String, dynamic> map) {
    return Image(
      imageId: map['image_id'] as String,
      owner: map['image_owner'] as String,
      firstName: map['first_name'],
      lastName: map['last_name'],
      imageCaption: map['caption'] != null ? map['caption'] as String : '',
      uploadDateTime: DateTime.parse(map['created_at']),
      likes: map['likes'],
      upvotes: map['upvotes'],
      userLiked: map['user_liked'],
      userUpvoted: map['user_upvoted'],
      likesUID: [],
      upvotesUID: [],
      commentMap: {},
    );
  }

  factory Image.from(Image image) {
    return Image(
      imageId: image.imageId,
      owner: image.owner,
      firstName: image.firstName,
      lastName: image.lastName,
      uploadDateTime: image.uploadDateTime,
      imageCaption: image.imageCaption,
      likes: image.likes,
      upvotes: image.upvotes,
      userLiked: image.userLiked,
      userUpvoted: image.userUpvoted,
      commentMap: image.commentMap,
      likesUID: image.likesUID,
      upvotesUID: image.upvotesUID,
    );
  }

  List<Comment> get comments {
    return commentMap.values.toList();
  }

  String get imageReq {
    String requestUrl = "${dotenv.env['URL']}/image?id=$imageId";

    return requestUrl;
  }

  String get avatarReq {
    String requestUrl = "${dotenv.env['URL']}image?id=$owner";

    return requestUrl;
  }

  String get fullName {
    String fullName = "$firstName $lastName";

    return fullName;
  }

  String get dateString {
    var newFormat = DateFormat.yMMMMd('en_US');
    String updatedDt = newFormat.format(uploadDateTime);
    return updatedDt; // 20-04-03
  }

  String get timeString {
    var newFormat = DateFormat("jm");
    String updatedDt = newFormat.format(uploadDateTime);
    return updatedDt; // 20-04-03
  }

  String toJson() => json.encode(toMap());

  factory Image.fromJson(String source) =>
      Image.fromMap(json.decode(source) as Map<String, dynamic>);
}
