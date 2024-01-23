import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/engager.dart';
import 'package:shared_photo/utils/api_variables.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Image {
  String imageId;
  String owner;
  String firstName;
  String lastName;
  String imageCaption;
  DateTime uploadDateTime;
  List<Comment> comments;
  List<Engager> likesUID;
  List<Engager> upvotesUID;

  Image({
    required this.imageId,
    required this.owner,
    required this.firstName,
    required this.lastName,
    required this.uploadDateTime,
    required this.imageCaption,
    required this.comments,
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
    List<Engager> likesUID = [];
    List<Engager> upvotesUID = [];
    dynamic jsonUpvotes = map['upvoted_users'];
    dynamic jsonLikers = map['liked_users'];

    if (jsonUpvotes != null) {
      for (var item in jsonUpvotes) {
        Engager upvoter = Engager.fromMap(item);

        upvotesUID.add(upvoter);
      }
    }

    if (jsonLikers != null) {
      for (var item in jsonLikers) {
        Engager likers = Engager.fromMap(item);

        likesUID.add(likers);
      }
    }

    return Image(
      imageId: map['image_id'] as String,
      owner: map['image_owner'] as String,
      firstName: map['first_name'],
      lastName: map['last_name'],
      imageCaption: map['caption'] != null ? map['caption'] as String : '',
      uploadDateTime: DateTime.parse(map['created_at']),
      likesUID: likesUID,
      upvotesUID: upvotesUID,
      comments: [],
    );
  }

  int get upvotes => upvotesUID.length;

  int get likes => likesUID.length;

  String get imageReq {
    String requestUrl = "$goRepoDomain/image?id=$imageId";

    return requestUrl;
  }

  String get avatarReq {
    String requestUrl = "$goRepoDomain/image?id=$owner";

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
