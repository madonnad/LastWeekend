part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final List<Album> myAlbums;
  final List<Image> myImages;
  final List<Friend> myFriends;
  final List<Notification> myNotifications;
  final bool? isLoading;
  final String? error;

  const ProfileState({
    required this.myAlbums,
    required this.myImages,
    required this.myFriends,
    required this.myNotifications,
    this.isLoading,
    this.error,
  });

  static const empty = ProfileState(
    myAlbums: [],
    myImages: [],
    myFriends: [],
    myNotifications: [],
    isLoading: false,
    error: '',
  );

  ProfileState copyWith({
    List<Album>? myAlbums,
    List<Image>? myImages,
    List<Friend>? myFriends,
    List<Notification>? myNotifications,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      myAlbums: myAlbums ?? this.myAlbums,
      myImages: myImages ?? this.myImages,
      myFriends: myFriends ?? this.myFriends,
      myNotifications: myNotifications ?? this.myNotifications,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props =>
      [myImages, myAlbums, myNotifications, myFriends, isLoading, error];
}
