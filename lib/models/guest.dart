import 'package:shared_photo/models/friend.dart';

enum InviteStatus { accept, decline, pending }

class Guest {
  final Friend friend;
  final InviteStatus status;

  Guest({required this.friend, required this.status});
}
