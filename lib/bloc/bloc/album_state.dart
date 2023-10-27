part of 'album_bloc.dart';

class AlbumState extends Equatable {
  final Album album;

  const AlbumState({
    required this.album,
  });

  static final empty = AlbumState(album: Album.empty);

  AlbumState copyWith({Album? album}) {
    return AlbumState(
      album: album ?? this.album,
    );
  }

  @override
  List<Object> get props => [album];
}
