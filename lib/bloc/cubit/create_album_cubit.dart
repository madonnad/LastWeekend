import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/custom_exception.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';

part 'create_album_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  UserRepository userRepository;
  DataRepository dataRepository;

  CreateEventCubit({
    required this.userRepository,
    required this.dataRepository,
  }) : super(
          CreateEventState(
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

  // Getting new friends from FriendRepo
  void addFriendToFriendsList(Friend friend) {
    Map<String, Friend> friendMap = Map.from(state.friendsMap);
    String key = friend.uid;

    if (!friendMap.containsKey(key) || friendMap[key] != friend) {
      friendMap[key] = friend;
      emit(state.copyWith(friendsMap: friendMap));
    }
  }

  // Adding friends to current event
  void handleFriendAddRemoveFromEvent(Friend friend) {
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

  void addImage(String? imagePath) {
    emit(state.copyWith(albumCoverImagePath: imagePath));
  }

  Future<bool> createEvent() async {
    emit(state.copyWith(loading: true));
    bool success = false;
    String? error;

    (success, error) = await dataRepository.createAlbum(state: state);

    if (success) {
      emit(state.copyWith(loading: false));

      // FirebaseAnalytics.instance.logEvent(
      //   name: "event_created",
      //   parameters: {
      //     "invite_count": state.invitedUIDList.length,
      //   },
      // );

      return success;
    } else {
      CustomException exception = CustomException(errorString: error);
      emit(state.copyWith(loading: false, exception: exception));
      emit(state.copyWith(loading: false, exception: CustomException.empty));

      return success;
    }
  }

  void setDuration(DurationEvent duration, {DateTime? datetime}) {
    DateTime revealDateTime = DateTime.now();

    switch (duration) {
      case DurationEvent.oneDay:
        revealDateTime = revealDateTime.add(Duration(hours: 24));
      case DurationEvent.twoDays:
        revealDateTime = revealDateTime.add(Duration(days: 2));
      case DurationEvent.oneWeek:
        revealDateTime = revealDateTime.add(Duration(days: 7));
      case DurationEvent.custom:
        if (datetime != null) {
          emit(state.copyWith(
            durationEvent: duration,
            revealDateTime: datetime,
            revealTimeOfDay: TimeOfDay.fromDateTime(datetime),
          ));
          return;
        }
    }

    TimeOfDay revealTimeOfDay = TimeOfDay.fromDateTime(revealDateTime);

    emit(state.copyWith(
      durationEvent: duration,
      revealDateTime: revealDateTime,
      revealTimeOfDay: revealTimeOfDay,
    ));
  }

  void setRevealDate(DateTime dateTime) {
    emit(state.copyWith(revealDateTime: dateTime));
  }

  void setRevealTime(TimeOfDay time) {
    emit(state.copyWith(revealTimeOfDay: time));
  }

  void setVisibilityMode(AlbumVisibility visibility) {
    emit(state.copyWith(visibility: visibility));
  }

  void setEventTitle(String text) {
    emit(state.copyWith(eventTitle: text));
  }

  void initializeCubit() {
    emit(state.copyWith(friendsMap: Map.from(userRepository.friendMap)));
  }
}
