import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/guest.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DataRepository dataRepository;
  User user;

  DashboardBloc({
    required this.dataRepository,
    required this.user,
  }) : super(DashboardState.empty) {
    on<InitializeDash>((event, emit) {
      emit(state.copyWith(
        activeAlbumMap: dataRepository.activeAlbums(),
      ));
    });

    on<AddAlbumToMap>(
      (event, emit) {
        Map<String, Album> albumMap = Map.from(state.activeAlbumMap);

        Album album = event.album;
        String key = album.albumId;

        albumMap.update(key, (value) => album, ifAbsent: () => album);

        emit(state.copyWith(activeAlbumMap: albumMap));
      },
    );

    on<UpdateAlbumInMap>((event, emit) {
      Map<String, Album> albumMap = Map.from(state.activeAlbumMap);

      Album album = event.album;
      String key = album.albumId;

      albumMap.update(key, (value) => album, ifAbsent: () => album);
      emit(state.copyWith(activeAlbumMap: albumMap));
    });

    on<RemoveAlbumInMap>(
      (event, emit) {
        Map<String, Album> albumMap = Map.from(state.activeAlbumMap);

        Album album = event.album;
        String key = album.albumId;

        albumMap.remove(key);
        emit(state.copyWith(activeAlbumMap: albumMap));
      },
    );

    // Stream Listeners
    dataRepository.albumStream.listen((event) {
      StreamOperation type = event.$1;
      Album album = event.$2;

      // Check if user is in the album that was passed
      bool userIsGuest = false;

      for (Guest guest in album.guests) {
        if (guest.uid == user.id && guest.status == RequestStatus.accepted) {
          userIsGuest = true;
        }
      }

      bool userIsOwner = album.albumOwner == user.id;

      if (((userIsGuest || userIsOwner) && album.phase == AlbumPhases.open) ||
          type == StreamOperation.delete) {
        switch (type) {
          case StreamOperation.add:
            add(AddAlbumToMap(album: album));
          case StreamOperation.update:
            add(UpdateAlbumInMap(album: album));
          case StreamOperation.delete:
            add(RemoveAlbumInMap(album: album));
        }
      }
    });

    add(const InitializeDash());
  }
}
