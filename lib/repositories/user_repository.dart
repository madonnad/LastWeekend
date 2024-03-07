import 'dart:async';

import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/services/user_service.dart';

class UserRepository {
  User user;
  Map<String, Friend> friendMap = {};

  // Controllers
  final _friendController =
      StreamController<(StreamOperation, Friend)>.broadcast();

  // Stream Getters
  Stream<(StreamOperation, Friend)> get friendStream =>
      _friendController.stream;

  // Initializer
  UserRepository({required this.user}) {
    _setFriendsList();
  }

  // Functions
  Future<void> _setFriendsList() async {
    List<Friend> fetchedFriends = await UserService.getFriendsList(user.token);

    for (Friend friend in fetchedFriends) {
      friendMap.putIfAbsent(friend.uid, () => friend);
      _friendController.add((StreamOperation.add, friend));
    }
  }
}
