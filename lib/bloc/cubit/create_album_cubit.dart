import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/repositories/data_repository.dart';
import 'package:shared_photo/repositories/go_repository.dart';

part 'create_album_state.dart';

class CreateAlbumCubit extends Cubit<CreateAlbumState> {
  AppBloc appBloc;
  ProfileBloc profileBloc;
  DataRepository dataRepository;
  GoRepository goRepository;
  List<Friend> _friendsList = [];
  CreateAlbumCubit(
      {required this.profileBloc,
      required this.appBloc,
      required this.dataRepository,
      required this.goRepository})
      : super(
          CreateAlbumState(
            albumName: TextEditingController(),
            friendSearch: TextEditingController(),
          ),
        ) {
    _friendsList = profileBloc.state.myFriends;
  }

  void handleFriendAddRemoveFromAlbum(Friend friend) {
    List<Friend> currentFriendList = List.from(state.friendsList);
    bool friendIsInList = currentFriendList
        .where((element) => element.uid == friend.uid)
        .isNotEmpty;

    if (friendIsInList) {
      currentFriendList.removeWhere((element) => element.uid == friend.uid);
      emit(state.copyWith(friendsList: currentFriendList));
      createModalString();
    } else {
      currentFriendList.add(friend);
      emit(state.copyWith(
        friendsList: currentFriendList,
        friendState: FriendState.added,
        friendSearch: TextEditingController(),
      ));
      createModalString();
    }
  }

  void createModalString() {
    int addedFriendsLength = state.friendsList.length;
    if (addedFriendsLength == 1) {
      String genString = state.friendsList[0].firstName;
      emit(state.copyWith(modalTextString: genString));
    } else if (addedFriendsLength == 2) {
      String genString =
          '${state.friendsList[0].firstName} & ${state.friendsList[1].firstName}';
      emit(state.copyWith(modalTextString: genString));
    } else if (addedFriendsLength > 2) {
      int numMorePeople = state.friendsList.length - 2;
      String genString =
          '${state.friendsList[0].firstName}, ${state.friendsList[1].firstName} & $numMorePeople other friends';
      emit(state.copyWith(modalTextString: genString));
    }
  }

  void searchFriendByName() async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<Friend> lookupResult = [];

    for (var friend in _friendsList) {
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
      checkToShowState();
    }
  }

  void checkToShowState() {
    if (state.friendSearch!.text.isEmpty && state.friendsList.isEmpty) {
      emit(state.copyWith(friendState: FriendState.empty));
    } else if (state.friendSearch!.text.isEmpty &&
        state.friendsList.isNotEmpty) {
      emit(state.copyWith(friendState: FriendState.added));
    }
  }

  void addImage(String? imagePath) {
    emit(state.copyWith(albumCoverImagePath: imagePath));
  }

  Future<void> createAlbum() async {
    try {
      final String token = appBloc.state.user.token;
      final String? imageId = await goRepository.postNewAlbum(token, state);
      if (imageId == null) {
        throw const FormatException("Failed creating new image");
      }
      final String? imagePath =
          state.albumCoverImagePath != null ? state.albumCoverImagePath! : null;
      if (imagePath == null) {
        throw const FormatException("No image path was provided to upload");
      }
      bool success =
          await goRepository.uploadNewImage(token, imagePath, imageId);
      if (success == false) {
        throw const FormatException("Image upload failed");
      }

      /*String albumCoverId =
          await dataRepository.createNewImageRecord(uid: appBloc.state.user.id);

      Album newAlbum = Album(
        albumId: '',
        albumCoverId: albumCoverId,
        albumName: state.albumName.text,
        albumOwner: appBloc.state.user.id,
        lockDateTime: state.finalLockDateTime.toIso8601String(),
        unlockDateTime: state.finalUnlockDateTime.toIso8601String(),
        revealDateTime: state.finalRevealDateTime.toIso8601String(),
      );*/

      /*await dataRepository.insertImageToBucket(
        imageUID: albumCoverId,
        filePath: File(
          state.albumCoverImagePath!,
        ),
      );

    String albumUid = await dataRepository.createAlbumRecord(newAlbum);

      dataRepository.addUsersToAlbum(
        creatorUid: appBloc.state.user.id,
        friendUids: state.friendUIDList,
        albumUid: albumUid,
      );*/
    } catch (e) {
      print(e);
    }
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
}
