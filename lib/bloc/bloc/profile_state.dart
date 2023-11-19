part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final List<Album> myAlbums;
  final List<Image> myImages;
  final List<Friend> myFriends;
  final List<Notification> myNotifications;
  final bool showNotification;
  final bool? isLoading;
  final String? error;

  const ProfileState({
    required this.myAlbums,
    required this.myImages,
    required this.myFriends,
    required this.myNotifications,
    required this.showNotification,
    this.isLoading,
    this.error,
  });

  static const empty = ProfileState(
    myAlbums: [],
    myImages: [],
    myFriends: [],
    myNotifications: [],
    showNotification: false,
    isLoading: false,
    error: '',
  );

  ProfileState copyWith({
    List<Album>? myAlbums,
    List<Image>? myImages,
    List<Friend>? myFriends,
    List<Notification>? myNotifications,
    bool? showNotification,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      myAlbums: myAlbums ?? this.myAlbums,
      myImages: myImages ?? this.myImages,
      myFriends: myFriends ?? this.myFriends,
      myNotifications: myNotifications ?? this.myNotifications,
      showNotification: showNotification ?? this.showNotification,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<Album> get activeAlbums {
    List<Album> albumList = [];
    for (final album in myAlbums) {
      if (album.phase != AlbumPhases.reveal) {
        albumList.add(album);
      }
    }
    return albumList;
  }

  List<Album> get revealedAlbums {
    List<Album> albumList = [];
    for (final album in myAlbums) {
      if (album.phase == AlbumPhases.reveal) {
        albumList.add(album);
      }
    }
    return albumList;
  }

  @override
  List<Object?> get props => [
        myImages,
        myAlbums,
        myNotifications,
        myFriends,
        isLoading,
        error,
        showNotification
      ];
}
