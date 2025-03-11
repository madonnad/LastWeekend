import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/custom_exception.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/services/request_service.dart';
import 'package:shared_photo/services/user_service.dart';
part 'friend_profile_state.dart';

class FriendProfileCubit extends Cubit<FriendProfileState> {
  String lookupUid;
  User user;
  DataRepository dataRepository;
  FriendProfileCubit({
    required this.lookupUid,
    required this.user,
    required this.dataRepository,
  }) : super(FriendProfileState.empty(user)) {
    initializeCubit();
  }

  void initializeCubit() async {
    emit(state.copyWith(loading: true));

    AnonymousFriend result =
        await UserService.getSearchedUser(user.token, lookupUid);

    List<Album> revealedAlbums =
        await dataRepository.getRevealedAlbumsByAlbumID(result.albumIDs);

    revealedAlbums
        .sort((a, b) => b.creationDateTime.compareTo(a.creationDateTime));
    print(revealedAlbums
        .any((test) => test.albumId == "4ae4216a-5305-4d74-ba45-3af385a5d630"));

    print(revealedAlbums
        .firstWhere(
            (test) => test.albumId == "4ae4216a-5305-4d74-ba45-3af385a5d630")
        .guests
        .length);

    emit(state.copyWith(
        anonymousFriend: result, albumList: revealedAlbums, loading: false));
    updateEventByDatetime();
  }

  void sendFriendRequest() async {
    emit(state.copyWith(friendStatusLoading: true));
    RequestService.sendFriendRequest(user.token, lookupUid).then((result) {
      bool success = result.$1;
      String? exception = result.$2;
      if (success) {
        AnonymousFriend updatedFriend = state.anonymousFriend.copyWith(
          friendStatus: FriendStatus.pending,
        );
        emit(state.copyWith(
            anonymousFriend: updatedFriend, friendStatusLoading: false));
      } else {
        CustomException customException =
            CustomException(errorString: exception);
        emit(state.copyWith(
          exception: customException,
          friendStatusLoading: false,
        ));
        emit(state.copyWith(exception: null));
      }
    });
  }

  void updateEventByDatetime() {
    Map<String, List<Album>> eventDateMap = {};
    FriendStatus currentStatus = state.anonymousFriend.friendStatus;

    for (Album album in state.albumList) {
      AlbumVisibility visibility = album.visibility;
      bool userInAlbum = album.guests.any((guest) => guest.uid == user.id);

      switch (visibility) {
        case AlbumVisibility.public:
          _addEventToMap(eventDateMap, album);
        case AlbumVisibility.friends:
          if (currentStatus == FriendStatus.friends || userInAlbum) {
            _addEventToMap(eventDateMap, album);
          }
        case AlbumVisibility.private:
          if (userInAlbum) {
            _addEventToMap(eventDateMap, album);
          }
      }
    }
    emit(state.copyWith(eventsByDatetime: eventDateMap));
  }

  Map<String, List<Album>> _addEventToMap(
      Map<String, List<Album>> eventDateMap, Album album) {
    String text = '';
    DateTime tempDT = album.creationDateTime;

    if (tempDT.year == DateTime.now().year) {
      text = DateFormat("MMMM").format(tempDT);
    } else {
      text = DateFormat("MMM yyyy").format(tempDT);
    }

    if (eventDateMap[text] != null) {
      List<Album> tempAlbumList = eventDateMap[text]!;
      tempAlbumList.add(album);
    } else {
      eventDateMap[text] = [album];
    }
    return eventDateMap;
  }
}
