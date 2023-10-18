part of 'album_bloc.dart';

enum AlbumPhases { invite, unlock, lock, reveal }

class AlbumState extends Equatable {
  final Album album;
  final List<Guest> guestList;
  final AlbumPhases phase;

  const AlbumState({
    required this.album,
    required this.guestList,
    required this.phase,
  });

  static final empty = AlbumState(
      album: Album.empty, guestList: const [], phase: AlbumPhases.invite);

  AlbumState copyWith(
      {Album? album, List<Guest>? guestList, AlbumPhases? phase}) {
    return AlbumState(
        album: album ?? this.album,
        guestList: guestList ?? this.guestList,
        phase: phase ?? this.phase);
  }

  @override
  List<Object> get props => [album, guestList, phase];
}
