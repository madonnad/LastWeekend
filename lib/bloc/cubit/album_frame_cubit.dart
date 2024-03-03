import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'album_frame_state.dart';

class AlbumFrameCubit extends Cubit<AlbumFrameState> {
  DataRepository dataRepository;
  Album album;
  AlbumFrameCubit({required this.album, required this.dataRepository})
      : super(
          AlbumFrameState(
            album: album,
            viewMode: AlbumViewMode.popular,
          ),
        ) {
    // Initialize Frame State with Empty Album Image Map
    initializeFrameState();

    dataRepository.imageStream.listen((event) {
      Image newImage = event.image;
      String albumID = event.albumID;
      String imageID = event.imageID;

      if (album.albumId == albumID) {
        updateImageInAlbum(imageID, newImage);
      }
    });
  }

  void updateImageInAlbum(String imageID, Image image) {
    if (state.imageMap.containsKey(imageID)) {
      Map<String, Image> newImageMap = Map.from(state.imageMap);
      newImageMap[imageID] = image;
      emit(state.copyWith(imageMap: newImageMap));
    }
  }

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

  void initializeFrameState() {
    emit(state.copyWith(imageMap: album.imageMap));
    Album emptyImageAlbum = state.album;
    emptyImageAlbum.imageMap = {};
    emit(state.copyWith(album: emptyImageAlbum));
  }
}
