import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart' as img;
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';

part 'album_frame_state.dart';

class AlbumFrameCubit extends Cubit<AlbumFrameState> {
  RealtimeRepository realtimeRepository;
  DataRepository dataRepository;
  Album album;
  late StreamSubscription imageStreamSubscription;
  AlbumFrameCubit({
    required this.album,
    required this.dataRepository,
    required this.realtimeRepository,
  }) : super(
          AlbumFrameState(
            album: album,
            viewMode: AlbumViewMode.popular,
            pageController: PageController(),
          ),
        ) {
    realtimeRepository.openAlbumChannelWebSocket(album.albumId);
    //checkGuestListChange();

    // Set Internal Ranked Images
    setRankedImages();
    if (state.images.isNotEmpty) {
      emit(state.copyWith(selectedImage: state.images[0]));
    }

    imageStreamSubscription = dataRepository.imageStream.listen((event) {
      img.Image newImage = event.image;
      String albumID = event.albumID;
      String imageID = event.imageID;

      if (album.albumId == albumID) {
        updateImageInAlbum(imageID, newImage);
      }
    });
  }

  // void checkGuestListChange() async {
  //   emit(state.copyWith(loading: true));

  //   Album album = Album.from(state.album);
  //   album.guests = await dataRepository.updateAlbumsGuests(state.album.albumId);

  //   emit(state.copyWith(album: album, loading: false));
  // }

  void updateImageInAlbum(String imageID, img.Image image) {
    if (state.album.imageMap.containsKey(imageID)) {
      Album album = Album.from(state.album);
      album.imageMap[imageID] = image;
      emit(state.copyWith(album: album));
      setRankedImages();
    }
  }

  void setRankedImages() {
    List<img.Image> rankedImages = List.from(state.album.images);
    List<img.Image> topThreeImages = [];

    // Set Ranked
    rankedImages.sort((a, b) {
      if (a.upvotes == b.upvotes) {
        return a.uploadDateTime.compareTo(b.uploadDateTime);
      } else {
        return b.upvotes.compareTo(a.upvotes);
      }
    });

    List<img.Image> remainingRankedImages = List.from(rankedImages);

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

  @override
  Future<void> close() {
    realtimeRepository.closeAlbumChannelWebSocket();
    imageStreamSubscription.cancel();
    return super.close();
  }
}
