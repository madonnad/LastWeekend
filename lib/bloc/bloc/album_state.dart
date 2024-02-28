part of 'album_bloc.dart';

class AlbumState extends Equatable {
  final User user;
  final HashMap<String, Album> appAlbumMap;

  const AlbumState({
    required this.user,
    required this.appAlbumMap,
  });

  factory AlbumState.empty({required User user}) {
    return AlbumState(
      user: user,
      appAlbumMap: HashMap<String, Album>(),
    );
  }

   List<Album> get activeAlbums {
    List<Album> activeAlbums = [];
    List<Album> profileAlbums = appAlbumMap.values
        .where((album) => album.guests.any((guest) => guest.uid == user.id))
        .toList();
    for (final album in profileAlbums) {
      if (album.phase != AlbumPhases.reveal) {
        activeAlbums.add(album);
      }
    }
    return activeAlbums;
   }

  List<Album> get unlockedAlbums {
    return activeAlbums
        .where((album) => album.phase == AlbumPhases.unlock)
        .toList();
  }

  List<Album> get appAlbumList {
    return appAlbumMap.values
        .where((album) => album.phase == AlbumPhases.reveal)
        .toList();
  }

  List<Album> get profileAlbumsList {
    return appAlbumMap.values
        .where((album) {
          return album.guests.any((guest) => guest.uid == user.id) && album.phase == AlbumPhases.reveal;
          })
        .toList();
  }

  AlbumState copyWith({
    HashMap<String, Album>? appAlbumMap,
    User? user,
  }) {
    return AlbumState(
      appAlbumMap: appAlbumMap ?? this.appAlbumMap,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [appAlbumMap];
}
