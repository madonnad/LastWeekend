part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User user;
  final Map<String, Album> myAlbumsMap;
  final List<Photo> myImages;
  final Map<String, Friend> myFriendsMap;
  final List<Notification> myNotifications;
  final bool showNotification;
  final bool? isLoading;
  final String? error;

  const ProfileState({
    required this.user,
    required this.myAlbumsMap,
    required this.myImages,
    required this.myFriendsMap,
    required this.myNotifications,
    required this.showNotification,
    this.isLoading,
    this.error,
  });

  static const empty = ProfileState(
    user: User.empty,
    myAlbumsMap: {},
    myImages: [],
    myFriendsMap: {},
    myNotifications: [],
    showNotification: false,
    isLoading: false,
    error: '',
  );

  static ProfileState createWithUser({required User user}) {
    return ProfileState(
      user: user,
      myAlbumsMap: {},
      myImages: [],
      myFriendsMap: {},
      myNotifications: [],
      showNotification: false,
      isLoading: false,
      error: '',
    );
  }

  ProfileState copyWith({
    User? user,
    Map<String, Album>? myAlbumsMap,
    List<Photo>? myImages,
    Map<String, Friend>? myFriendsMap,
    List<Notification>? myNotifications,
    bool? showNotification,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      myAlbumsMap: myAlbumsMap ?? this.myAlbumsMap,
      myImages: myImages ?? this.myImages,
      myFriendsMap: myFriendsMap ?? this.myFriendsMap,
      myNotifications: myNotifications ?? this.myNotifications,
      showNotification: showNotification ?? this.showNotification,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<Album> get myAlbums {
    List<Album> albumList = myAlbumsMap.values.toList();
    albumList.sort((a, b) => b.creationDateTime.compareTo(a.creationDateTime));
    return albumList;
  }

  List<Friend> get myFriends {
    return myFriendsMap.values.toList();
  }

  @override
  List<Object?> get props => [
        user,
        myAlbumsMap,
        myImages,
        myAlbumsMap,
        myNotifications,
        myFriendsMap,
        isLoading,
        error,
        showNotification
      ];
}
