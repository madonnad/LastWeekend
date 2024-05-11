import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/models/album.dart';
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
    initalizeCubit();
  }

  void initalizeCubit() async {
    emit(state.copyWith(loading: true));

    AnonymousFriend result =
        await UserService.getSearchedUser(user.token, lookupUid);

    List<Album> revealedAlbums =
        await dataRepository.getRevealedAlbumsByAlbumID(result.albumIDs);

    emit(state.copyWith(
        anonymousFriend: result, albumList: revealedAlbums, loading: false));
  }

  void sendFriendRequest() async {
    emit(state.copyWith(friendStatusLoading: true));
    RequestService.sendFriendRequest(user.token, lookupUid).then((success) {
      if (success) {
        AnonymousFriend updatedFriend = state.anonymousFriend.copyWith(
          friendStatus: FriendStatus.pending,
        );
        emit(state.copyWith(
            anonymousFriend: updatedFriend, friendStatusLoading: false));
      } else {
        emit(state.copyWith(
          exception: "Failed to send friend request",
          friendStatusLoading: false,
        ));
        emit(state.copyWith(exception: ""));
      }
    });
  }
}
