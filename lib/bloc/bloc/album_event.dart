part of 'album_bloc.dart';

sealed class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class AddGlobalAlbumEvent extends AlbumEvent {
  final Album album;

  const AddGlobalAlbumEvent({required this.album});
}

class AddActiveAlbumEvent extends AlbumEvent {
  final Album album;

  const AddActiveAlbumEvent({required this.album});
}
