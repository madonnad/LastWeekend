part of 'album_bloc.dart';

enum AlbumPhases { invite, unlock, lock, reveal }

class AlbumState extends Equatable {
  final Album album;

  const AlbumState({
    required this.album,
  });

  static final empty = AlbumState(album: Album.empty);

  AlbumState copyWith({Album? album, AlbumPhases? phase}) {
    return AlbumState(
      album: album ?? this.album,
    );
  }

  AlbumPhases get albumPhase {
    DateTime now = DateTime.now();
    DateTime unlock = DateTime.parse(album.unlockDateTime);
    DateTime lock = DateTime.parse(album.lockDateTime);
    DateTime reveal = DateTime.parse(album.revealDateTime);

    if (now.isBefore(unlock)) {
      return AlbumPhases.invite;
    }
    if (now.isBefore(lock)) {
      return AlbumPhases.unlock;
    }
    if (now.isBefore(reveal)) {
      return AlbumPhases.lock;
    }
    return AlbumPhases.reveal;
  }

  @override
  List<Object> get props => [album];
}
