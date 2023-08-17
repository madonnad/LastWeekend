import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/models/friend.dart';

part 'create_album_state.dart';

class CreateAlbumCubit extends Cubit<CreateAlbumState> {
  CreateAlbumCubit() : super(const CreateAlbumState());

  void searchFriendByName(List<Friend> blocFriendList) async {
    List<Friend> lookupResult = [];

    await Future.delayed(const Duration(milliseconds: 250));

    for (var friend in blocFriendList) {
      if (state.friendSearch!.text.isNotEmpty) {
        if (friend.firstName.contains(state.friendSearch!.text) ||
            friend.lastName.contains(state.friendSearch!.text)) {
          lookupResult.add(friend);
        }
      }
    }
    lookupResult.sort((a, b) =>
        a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase()));

    emit(state.copyWith(searchResult: lookupResult));
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
