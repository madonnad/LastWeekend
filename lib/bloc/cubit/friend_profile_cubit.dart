import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/services/user_service.dart';
import 'package:shared_photo/utils/api_variables.dart';

part 'friend_profile_state.dart';

class FriendProfileCubit extends Cubit<FriendProfileState> {
  String uid;
  String token;
  DataRepository dataRepository;
  FriendProfileCubit(
      {required this.uid, required this.token, required this.dataRepository})
      : super(FriendProfileState.empty) {
    initalizeCubit();
  }

  void initalizeCubit() async {
    emit(state.copyWith(loading: true));

    AnonymousFriend result = await UserService.getSearchedUser(token, uid);

    List<Album> revealedAlbums =
        await dataRepository.getRevealedAlbumsByAlbumID(result.albumIDs);

    emit(state.copyWith(
        anonymousFriend: result, albumList: revealedAlbums, loading: false));
  }
}
