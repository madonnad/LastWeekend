import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  DataRepository dataRepository;
  User user;

  AlbumBloc({required this.dataRepository, required this.user})
      : super(AlbumState.empty(user: user)) {
        
    // Event Handlers
    on<AddGlobalAlbumEvent>((event, emit) {
      Album album = event.album;
      HashMap<String, Album> appAlbumMap = HashMap.from(state.appAlbumMap);

      appAlbumMap.putIfAbsent(album.albumId, () => album);

      emit(state.copyWith(appAlbumMap: appAlbumMap));
    });

    dataRepository.albumStream.listen((event) {
      StreamOperation type = event.$1;
      Album album = event.$2;

      switch (type) {
        case StreamOperation.add:
          add(AddGlobalAlbumEvent(album: album));
        case StreamOperation.delete:
        case StreamOperation.update:
        default:
      }
    });
  }
}
