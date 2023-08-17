class Friend {
  final String uid;
  final String firstName;
  final String lastName;

  Friend({required this.uid, required this.firstName, required this.lastName});

  Friend.fromJson(Map<String, dynamic> json)
      : uid = json["user_id"],
        firstName = json["first_name"],
        lastName = json["last_name"];
}
