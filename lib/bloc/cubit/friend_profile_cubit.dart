import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';

part 'friend_profile_state.dart';

class FriendProfileCubit extends Cubit<FriendProfileState> {
  FriendProfileCubit() : super(FriendProfileState.empty) {
    //TODO: fetchAlbumsHere
    int test = 1;
    print('ello from profile init $test');
  }
}
