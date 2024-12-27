part of 'friend_profile_cubit.dart';

class FriendProfileState extends Equatable {
  final AnonymousFriend anonymousFriend;
  final List<Album> albumList;
  final Map<String, List<Album>> eventsByDatetime;
  final bool loading;
  final bool friendStatusLoading;
  final User user;
  final CustomException exception;

  const FriendProfileState({
    required this.anonymousFriend,
    required this.albumList,
    required this.eventsByDatetime,
    required this.loading,
    required this.friendStatusLoading,
    required this.user,
    this.exception = CustomException.empty,
  });

  static FriendProfileState empty(User user) => FriendProfileState(
      anonymousFriend: AnonymousFriend.empty,
      albumList: const [],
      eventsByDatetime: {},
      loading: false,
      friendStatusLoading: false,
      user: user,
      exception: CustomException.empty);

  FriendProfileState copyWith({
    AnonymousFriend? anonymousFriend,
    List<Album>? albumList,
    Map<String, List<Album>>? eventsByDatetime,
    bool? loading,
    bool? friendStatusLoading,
    CustomException? exception,
  }) {
    return FriendProfileState(
      anonymousFriend: anonymousFriend ?? this.anonymousFriend,
      albumList: albumList ?? this.albumList,
      eventsByDatetime: eventsByDatetime ?? this.eventsByDatetime,
      loading: loading ?? this.loading,
      friendStatusLoading: friendStatusLoading ?? this.friendStatusLoading,
      exception: exception ?? this.exception,
      user: user,
    );
  }

  List<Album> get publicVisAlbumList {
    return albumList
        .where((album) => album.visibility == AlbumVisibility.public)
        .toList();
  }

  List<Album> get pubAndFriendVizAlbumsNotJoint {
    return albumList
        .where((album) =>
            (album.visibility == AlbumVisibility.friends ||
                album.visibility == AlbumVisibility.public) &&
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
    return "${dotenv.env['URL']}/image?id=$uid";
  }

  @override
  List<Object> get props => [
        anonymousFriend,
        albumList,
        eventsByDatetime,
        loading,
        friendStatusLoading,
        user,
        exception,
      ];
}
