import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart' as img;
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'album_frame_state.dart';

class AlbumFrameCubit extends Cubit<AlbumFrameState> {
  DataRepository dataRepository;
  Album album;
  AlbumFrameCubit({
    required this.album,
    required this.dataRepository,
  }) : super(
          AlbumFrameState(
            album: album,
            viewMode: AlbumViewMode.popular,
            pageController: PageController(),
            selectedImage: album.images[0],
          ),
        ) {
    // Set Internal Ranked Images
    setRankedImages();

    dataRepository.imageStream.listen((event) {
      img.Image newImage = event.image;
      String albumID = event.albumID;
      String imageID = event.imageID;

      if (album.albumId == albumID) {
        updateImageInAlbum(imageID, newImage);
      }
    });
  }

  void updateImageInAlbum(String imageID, img.Image image) {
    if (state.album.imageMap.containsKey(imageID)) {
      Album album = state.album;
      Map<String, img.Image> newImageMap = Map.from(state.album.imageMap);
      newImageMap[imageID] = image;
      album.imageMap = newImageMap;
      emit(state.copyWith(album: album));
    }
  }

  void setRankedImages() {
    List<img.Image> rankedImages = List.from(state.images);
    List<img.Image> topThreeImages = [];
    List<img.Image> remainingRankedImages = List.from(rankedImages);

    // Set Ranked
    rankedImages.sort((a, b) => b.upvotes.compareTo(a.upvotes));

    // Set Top Three Images
    if (rankedImages.length > 3) {
      topThreeImages.addAll(rankedImages.getRange(0, 3).toList());
    } else if (rankedImages.isNotEmpty) {
      topThreeImages
          .addAll(rankedImages.getRange(0, rankedImages.length - 1).toList());
    } else {
      topThreeImages = [];
    }

    // Set Remaining Ranked Images
    if (remainingRankedImages.length > 3) {
      remainingRankedImages.removeRange(0, 3);
    } else {
      remainingRankedImages = [];
    }

    // Emit Ranked Images
    emit(state.copyWith(
      rankedImages: rankedImages,
      topThreeImages: topThreeImages,
      remainingRankedImages: remainingRankedImages,
    ));
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

  void initalizeImageFrameWithSelectedImage(int selectedIndex) {
    PageController pageController = PageController(initialPage: selectedIndex);
    img.Image image = state.imageFrameTimelineList[selectedIndex];
    emit(state.copyWith(selectedImage: image, pageController: pageController));
  }

  void nextImage() {
    state.pageController.nextPage(
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  void previousImage() {
    state.pageController.previousPage(
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }
}
