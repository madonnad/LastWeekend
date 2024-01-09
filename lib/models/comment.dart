class Comment {
  String id;
  String imageID;
  String userID;
  String firstName;
  String lastName;
  String comment;
  DateTime createdAt;
  DateTime? updatedAt;

  Comment({
    required this.id,
    required this.imageID,
    required this.userID,
    required this.firstName,
    required this.lastName,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      imageID: map['image_id'],
      userID: map['user_id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      comment: map['comment'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt:
          map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
