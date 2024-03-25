import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/services/user_service.dart';
import 'package:shared_photo/utils/api_variables.dart';

part 'friend_profile_state.dart';

class FriendProfileCubit extends Cubit<FriendProfileState> {
  String uid;
  String token;
  FriendProfileCubit({required this.uid, required this.token})
      : super(FriendProfileState.empty) {
    initalizeCubit();
  }

  void initalizeCubit() async {
    emit(state.copyWith(loading: true));

    AnonymousFriend result = await UserService.getSearchedUser(token, uid);

    emit(state.copyWith(anonymousFriend: result, loading: false));
  }
}
