part of 'friend_profile_cubit.dart';

enum FriendStatus { friends, pending, notFriends }

class FriendProfileState extends Equatable {
  final String firstName;
  final String lastName;
  final String uid;
  final int numberOfFriends;
  final int numberOfAlbums;
  final FriendStatus friendStatus;
  final List<Album> albumList;

  const FriendProfileState(
      {required this.firstName,
      required this.lastName,
      required this.uid,
      required this.numberOfFriends,
      required this.numberOfAlbums,
      required this.friendStatus,
      required this.albumList});

  static const empty = FriendProfileState(
    firstName: '',
    lastName: '',
    uid: '',
    numberOfFriends: 0,
    numberOfAlbums: 0,
    friendStatus: FriendStatus.notFriends,
    albumList: [],
  );

  FriendProfileState copyWith({
    String? firstName,
    String? lastName,
    String? uid,
    int? numberOfFriends,
    int? numberOfAlbums,
    FriendStatus? friendStatus,
    List<Album>? albumList,
  }) {
    return FriendProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      uid: uid ?? this.uid,
      numberOfFriends: numberOfFriends ?? this.numberOfFriends,
      numberOfAlbums: numberOfAlbums ?? this.numberOfAlbums,
      friendStatus: friendStatus ?? this.friendStatus,
      albumList: albumList ?? this.albumList,
    );
  }

  @override
  List<Object> get props => [
        firstName,
        lastName,
        uid,
        numberOfFriends,
        numberOfAlbums,
        friendStatus,
        albumList,
      ];
}
