import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart' as img;

part 'new_album_frame_state.dart';

class NewAlbumFrameCubit extends Cubit<NewAlbumFrameState> {
  Album album;
  NewAlbumFrameCubit({required this.album})
      : super(
            NewAlbumFrameState(album: album, viewMode: AlbumViewMode.popular));

  void changePage(index) {
    String listString = state.filterList[index];
    AlbumViewMode viewMode = AlbumViewMode.popular;

    switch (listString) {
      case "Popular":
        viewMode = AlbumViewMode.popular;
      case "Guests":
        viewMode = AlbumViewMode.guests;
      case "Timeline":
        viewMode = AlbumViewMode.timeline;
    }

    emit(state.copyWith(viewMode: viewMode));
  }

  void changeViewMode(AlbumViewMode viewMode) {
    emit(state.copyWith(viewMode: viewMode));
  }
}
