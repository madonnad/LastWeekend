// ignore_for_file: public_member_api_docs, sort_constructors_first
class Image {
  String imageId;
  String owner;
  String imageUrl;
  String? imageCaption;
  int upvotes;
  DateTime uploadDateTime;

  Image({
    required this.imageId,
    required this.owner,
    required this.upvotes,
    required this.uploadDateTime,
    required this.imageUrl,
    this.imageCaption,
  });

  @override
  String toString() {
    return 'Image(imageId: $imageId, owner: $owner, imageUrl: $imageUrl, imageCaption: $imageCaption, upvotes: $upvotes, uploadDateTime: $uploadDateTime)';
  }
}
