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
  final _userController = StreamController<(StreamOperation, User)>();

  // Stream Getters
  Stream<(StreamOperation, Friend)> get friendStream =>
      _friendController.stream;
  Stream<(StreamOperation, User)> get userStream => _userController.stream;

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

  Future<(String?, String?, String?)> updateUsersFirstLast(
      String first, String last) async {
    String? firstName;
    String? lastName;
    String? error;
    (firstName, lastName, error) =
        await UserService.updateUsersName(user.token, first, last);

    if (error != null) {
      return (first, last, error);
    }

    User updatedUser = user.copyWith(firstName: firstName, lastName: lastName);

    user = updatedUser;

    _userController.add((StreamOperation.update, updatedUser));

    return (firstName, lastName, error);
  }
}
