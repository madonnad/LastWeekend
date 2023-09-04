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

class NotificationRemoved extends ProfileEvent {
  final String identifier;
  final NotificationType notificationType;

  const NotificationRemoved(
      {required this.identifier, required this.notificationType});

  @override
  List<Object?> get props => [identifier, notificationType];
}
