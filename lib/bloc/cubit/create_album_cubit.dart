import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';

part 'create_album_state.dart';

class CreateAlbumCubit extends Cubit<CreateAlbumState> {
  UserRepository userRepository;

  CreateAlbumCubit({required this.userRepository})
      : super(
          CreateAlbumState(
            albumName: TextEditingController(),
            friendSearch: TextEditingController(),
            friendsMap: const {},
          ),
        ) {
    userRepository.friendStream.listen((event) {
      StreamOperation type = event.$1;
      Friend friend = event.$2;

      switch (type) {
        case StreamOperation.add:
          addFriendToFriendsList(friend);
        case StreamOperation.update:
        case StreamOperation.delete:
      }
    });
    initializeCubit();
  }

  void addFriendToFriendsList(Friend friend) {
    Map<String, Friend> friendMap = Map.from(state.friendsMap);
    String key = friend.uid;

    if (!friendMap.containsKey(key) || friendMap[key] != friend) {
      friendMap[key] = friend;
      emit(state.copyWith(friendsMap: friendMap));
    }
  }

  void handleFriendAddRemoveFromAlbum(Friend friend) {
    List<Friend> currentInvited = List.from(state.invitedFriends);
    bool friendIsInList = state.invitedUIDList.contains(friend.uid);

    if (friendIsInList) {
      currentInvited.removeWhere((element) => element.uid == friend.uid);
      emit(
        state.copyWith(invitedFriends: currentInvited),
      );
    } else {
      currentInvited.add(friend);
      emit(
        state.copyWith(invitedFriends: currentInvited),
      );
    }
  }

  void searchFriendByName() async {
    await Future.delayed(const Duration(milliseconds: 250));
    List<Friend> lookupResult = [];

    for (var friend in state.friendsList) {
      if (state.friendSearch!.text.isNotEmpty) {
        String catString =
            '${friend.firstName.toLowerCase()} ${friend.lastName.toLowerCase()}';
        if (catString.contains(state.friendSearch!.text.toLowerCase())) {
          lookupResult.add(friend);
        }
      }
    }
    lookupResult.sort((a, b) =>
        a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

    if (lookupResult.isNotEmpty) {
      emit(
        state.copyWith(
          searchResult: lookupResult,
          friendState: FriendState.searching,
        ),
      );
    } else {
      emit(state.copyWith(friendState: FriendState.empty));
    }
  }

  void checkToShowState() {
    if (state.friendSearch!.text.isEmpty) {
      emit(state.copyWith(friendState: FriendState.empty));
    }
  }

  void addImage(String? imagePath) {
    emit(state.copyWith(albumCoverImagePath: imagePath));
  }

  Future<void> createAlbum() async {
    // TODO: Implement the create album logic here and call Album Service.
    
    // try {
    //   final String? imageId = await AlbumService.postNewAlbum(token, state);
    //   if (imageId == null) {
    //     throw const FormatException("Failed creating new image");
    //   }
    //   final String? imagePath =
    //       state.albumCoverImagePath != null ? state.albumCoverImagePath! : null;
    //   if (imagePath == null) {
    //     throw const FormatException("No image path was provided to upload");
    //   }
    //   bool success =
    //       await ImageService.postAlbumCoverImage(token, imagePath, imageId);
    //   if (success == false) {
    //     throw const FormatException("Image upload failed");
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  void setUnlockDate(DateTime dateTime) {
    if (state.lockDateTime != null) {
      bool resetDate = (state.lockDateTime!.isBefore(dateTime));
      if (resetDate == true) {
        emit(state.copyWithNullLockDate());
      }
    }
    if (state.revealDateTime != null) {
      bool resetDate = (state.revealDateTime!.isBefore(dateTime));

      if (resetDate == true) {
        emit(state.copyWithNullRevealDate());
      }
    }

    emit(state.copyWith(unlockDateTime: dateTime));
  }

  void setUnlockTime(TimeOfDay time) {
    emit(state.copyWith(unlockTimeOfDay: time));
  }

  void setLockDate(DateTime dateTime) {
    if (state.revealDateTime != null) {
      bool resetDate = (state.revealDateTime!.isBefore(dateTime));

      if (resetDate == true) {
        emit(state.copyWithNullRevealDate());
      }
    }
    emit(state.copyWith(lockDateTime: dateTime));
  }

  void setLockTime(TimeOfDay time) {
    emit(state.copyWith(lockTimeOfDay: time));
  }

  void setRevealDate(DateTime dateTime) {
    emit(state.copyWith(revealDateTime: dateTime));
  }

  void setRevealTime(TimeOfDay time) {
    emit(state.copyWith(revealTimeOfDay: time));
  }

  void initializeCubit() {
    emit(state.copyWith(friendsMap: Map.from(userRepository.friendMap)));
  }
}
