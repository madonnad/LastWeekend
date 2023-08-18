import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/friend.dart';

part 'create_album_state.dart';

class CreateAlbumCubit extends Cubit<CreateAlbumState> {
  AppBloc appBloc;
  List<Friend> _appBlocFriendsList = [];
  CreateAlbumCubit({required this.appBloc})
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

    emit(
      state.copyWith(
        searchResult: lookupResult,
        friendState: FriendState.searching,
      ),
    );
  }

  void addFriendToAlbumFriendList(String uid) {}

  void checkToShowEmptyState() {
    if (state.friendSearch!.text.isEmpty && state.friendsList!.isEmpty) {
      emit(state.copyWith(friendState: FriendState.empty));
    }
  }

  void addImage(String? imagePath) {
    emit(state.copyWith(albumCoverImagePath: imagePath));
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
