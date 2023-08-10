import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Image {
  String imageId;
  String owner;
  String? imageUrl;
  String? imageCaption;
  int upvotes;
  DateTime uploadDateTime;

  Image({
    required this.imageId,
    required this.owner,
    required this.upvotes,
    required this.uploadDateTime,
    this.imageUrl,
    this.imageCaption,
  });

  @override
  String toString() {
    return 'Image(imageId: $imageId, owner: $owner, imageUrl: $imageUrl, imageCaption: $imageCaption, upvotes: $upvotes, uploadDateTime: $uploadDateTime)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image_id': imageId,
      'image_owner': owner,
      'caption': imageCaption,
      'upvotes': upvotes,
    };
  }

  factory Image.fromMap(Map<String, dynamic> map) {
    return Image(
      imageId: map['image_id'] as String,
      owner: map['image_owner'] as String,
      imageUrl: '',
      imageCaption: map['caption'] != null ? map['caption'] as String : null,
      upvotes: map['upvotes'] as int,
      uploadDateTime: DateTime.parse(map['created_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Image.fromJson(String source) =>
      Image.fromMap(json.decode(source) as Map<String, dynamic>);
}
