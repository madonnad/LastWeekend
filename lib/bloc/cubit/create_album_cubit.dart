import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/repositories/data_repository.dart';

part 'create_album_state.dart';

class CreateAlbumCubit extends Cubit<CreateAlbumState> {
  AppBloc appBloc;
  DataRepository dataRepository;
  List<Friend> _appBlocFriendsList = [];
  CreateAlbumCubit({required this.appBloc, required this.dataRepository})
      : super(
          CreateAlbumState(
            friendSearch: TextEditingController(),
          ),
        ) {
    if (appBloc.state is AuthenticatedState) {
      _appBlocFriendsList = appBloc.state.user.friendsList!;
    }
    appBloc.stream.listen(
      (event) {
        _appBlocFriendsList = appBloc.state.user.friendsList!;
      },
    );
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
      emit(state.copyWith(friendsList: currentFriendList));
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

    for (var friend in _appBlocFriendsList) {
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
    String imageUID =
        await dataRepository.createNewImageRecord(uid: appBloc.state.user.id);

    dataRepository.insertImageToBucket(
      imageUID: imageUID,
      filePath: File(
        state.albumCoverImagePath!,
      ),
    );
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

/*CreateAlbumState(
friendSearch: TextEditingController(),
friendsList: [
Friend(
uid: "12345",
firstName: 'Zoe',
lastName: 'Madonna',
),
Friend(
uid: "67890",
firstName: 'Jamie',
lastName: 'Kuppel',
)
],
),*/
