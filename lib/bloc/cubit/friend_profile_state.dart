part of 'friend_profile_cubit.dart';

class FriendProfileState extends Equatable {
  final AnonymousFriend anonymousFriend;
  final List<Album> albumList;
  final bool loading;

  const FriendProfileState({
    required this.anonymousFriend,
    required this.albumList,
    required this.loading,
  });

  static const empty = FriendProfileState(
    anonymousFriend: AnonymousFriend.empty,
    albumList: [],
    loading: false,
  );

  FriendProfileState copyWith({
    AnonymousFriend? anonymousFriend,
    List<Album>? albumList,
    bool? loading,
  }) {
    return FriendProfileState(
      anonymousFriend: anonymousFriend ?? this.anonymousFriend,
      albumList: albumList ?? this.albumList,
      loading: loading ?? this.loading,
    );
  }

  String get imageReq {
    String uid = anonymousFriend.uid;
    print(uid);
    print("$goRepoDomain/image?id=$uid");
    return "$goRepoDomain/image?id=$uid";
  }

  @override
  List<Object> get props => [
        anonymousFriend,
        albumList,
        loading,
      ];
}
