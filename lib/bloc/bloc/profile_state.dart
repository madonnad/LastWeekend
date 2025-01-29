part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final User user;
  final Map<String, Album> myAlbumsMap;
  final Map<String, List<Album>> myEventsByDatetime;
  final List<Photo> myImages;
  final Map<String, Friend> myFriendsMap;
  final List<Notification> myNotifications;
  final bool showNotification;
  final bool? isLoading;
  final String? error;

  const ProfileState({
    required this.user,
    required this.myAlbumsMap,
    required this.myEventsByDatetime,
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
    myEventsByDatetime: {},
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
      myAlbumsMap: const {},
      myEventsByDatetime: {},
      myImages: const [],
      myFriendsMap: const {},
      myNotifications: const [],
      showNotification: false,
      isLoading: false,
      error: '',
    );
  }

  ProfileState copyWith({
    User? user,
    Map<String, Album>? myAlbumsMap,
    Map<String, List<Album>>? myEventsByDatetime,
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
      myEventsByDatetime: myEventsByDatetime ?? this.myEventsByDatetime,
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
        myAlbumsMap.hashCode,
        myEventsByDatetime.hashCode,
        myImages,
        myAlbumsMap,
        myNotifications,
        myFriendsMap,
        isLoading,
        error,
        showNotification
      ];
}
