class Photo {
  String owner;
  String imageUrl;
  String? imageCaption;
  int upvotes;
  DateTime uploadDateTime;

  Photo({
    required this.owner,
    required this.imageUrl,
    required this.upvotes,
    required this.uploadDateTime,
  });
}
