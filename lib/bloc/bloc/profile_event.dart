part of 'profile_bloc.dart';

enum LoadLocation { init, list }

enum RequestAction { accept, deny }

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class InitializeProfile extends ProfileEvent {
  @override
  List<Object?> get props => [];
}

class AddFriendToList extends ProfileEvent {
  final Friend friend;

  const AddFriendToList({required this.friend});

  @override
  List<Object?> get props => [friend];
}

class AddAlbumToMap extends ProfileEvent {
  final Album album;

  const AddAlbumToMap({required this.album});

  @override
  List<Object?> get props => [album];
}

class FetchProfileAlbumCoverURL extends ProfileEvent {
  final int index;

  const FetchProfileAlbumCoverURL({required this.index});

  @override
  List<Object?> get props => [index];
}

class LoadNotifications extends ProfileEvent {
  final int index;
  final LoadLocation location;

  const LoadNotifications({required this.index, required this.location});

  @override
  List<Object?> get props => [index, location];
}

class ReceiveNotification extends ProfileEvent {
  final String identifier;
  final NotificationType notificationType;

  const ReceiveNotification(
      {required this.identifier, required this.notificationType});

  @override
  List<Object?> get props => [identifier, notificationType];
}

class FriendRequestEvent extends ProfileEvent {
  final RequestAction action;
  final String friendID;

  const FriendRequestEvent({required this.action, required this.friendID});

  @override
  List<Object?> get props => [action, friendID];
}

class AlbumRequestEvent extends ProfileEvent {
  final RequestAction action;
  final String albumID;

  const AlbumRequestEvent({required this.action, required this.albumID});

  @override
  List<Object?> get props => [action, albumID];
}

class UpdateStateEvent extends ProfileEvent {
  final NotificationType notificationType;
  final ProfileState updatedStateClass;

  const UpdateStateEvent(
      {required this.notificationType, required this.updatedStateClass});

  @override
  List<Object?> get props => [updatedStateClass];
}

class NotificationRemoved extends ProfileEvent {
  final String identifier;
  final NotificationType notificationType;

  const NotificationRemoved(
      {required this.identifier, required this.notificationType});

  @override
  List<Object?> get props => [identifier, notificationType];
}
