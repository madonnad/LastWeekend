part of 'profile_bloc.dart';

enum LoadLocation { init, list }

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class InitializeProfile extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class FetchProfileAlbumCoverURL extends ProfileEvent {
  final int index;

  const FetchProfileAlbumCoverURL({required this.index});

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends ProfileEvent {
  final int index;
  final LoadLocation location;

  const LoadNotifications({required this.index, required this.location});
  @override
  List<Object?> get props => [];
}
