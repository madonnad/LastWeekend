part of 'friend_profile_cubit.dart';

class FriendProfileState extends Equatable {
  final AnonymousFriend anonymousFriend;
  final List<Album> albumList;
  final bool loading;
  final bool friendStatusLoading;
  final User user;
  final String exception;

  const FriendProfileState(
      {required this.anonymousFriend,
      required this.albumList,
      required this.loading,
      required this.friendStatusLoading,
      required this.user,
      required this.exception});

  static FriendProfileState empty(User user) => FriendProfileState(
        anonymousFriend: AnonymousFriend.empty,
        albumList: const [],
        loading: false,
        friendStatusLoading: false,
        user: user,
        exception: "",
      );

  FriendProfileState copyWith({
    AnonymousFriend? anonymousFriend,
    List<Album>? albumList,
    bool? loading,
    bool? friendStatusLoading,
    String? exception,
  }) {
    return FriendProfileState(
      anonymousFriend: anonymousFriend ?? this.anonymousFriend,
      albumList: albumList ?? this.albumList,
      loading: loading ?? this.loading,
      friendStatusLoading: friendStatusLoading ?? this.friendStatusLoading,
      exception: exception ?? this.exception,
      user: user,
    );
  }

  List<Album> get publicVisAlbumList {
    return albumList
        .where((album) => album.visibility == Visibility.public)
        .toList();
  }

  List<Album> get pubAndFriendVizAlbumsNotJoint {
    return albumList
        .where((album) =>
            (album.visibility == Visibility.friends ||
                album.visibility == Visibility.public) &&
            !album.guests.any((guest) => guest.uid == user.id))
        .toList();
  }

  List<Album> get friendJointAlbumList {
    return albumList
        .where((album) => album.guests.any((guest) => guest.uid == user.id))
        .toList();
  }

  String get imageReq {
    String uid = anonymousFriend.uid;
    return "https://${dotenv.env['DOMAIN']}/image?id=$uid";
  }

  @override
  List<Object> get props => [
        anonymousFriend,
        albumList,
        loading,
        friendStatusLoading,
        user,
        exception,
      ];
}
