import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';

part 'album_frame_state.dart';

class AlbumFrameCubit extends Cubit<AlbumFrameState> {
  RealtimeRepository realtimeRepository;
  DataRepository dataRepository;
  String albumID;
  late StreamSubscription imageStreamSubscription;
  late StreamSubscription albumStreamSubscription;
  AlbumFrameCubit({
    required this.albumID,
    required this.dataRepository,
    required this.realtimeRepository,
  }) : super(
          AlbumFrameState(
            album: Album.empty,
            viewMode: AlbumViewMode.popular,
            pageController: PageController(),
            miniMapController: PageController(viewportFraction: 1 / 6),
          ),
        ) {
    // Fetch Album to Initalize
    initializeAlbum();

    realtimeRepository.openAlbumChannelWebSocket(albumID);
    //checkGuestListChange();

    imageStreamSubscription = dataRepository.imageStream.listen((event) {
      Photo newImage = event.image;
      String imageID = event.imageID;

      if (albumID == event.albumID) {
        updateImageInAlbum(imageID, newImage);
      }
    });

    albumStreamSubscription = dataRepository.albumStream.listen((event) {
      StreamOperation operation = event.$1;
      Album album = event.$2;
      if (album.albumId == albumID) {
        switch (operation) {
          case StreamOperation.add:
          case StreamOperation.update:
            emit(state.copyWith(album: album));
            setRankedImages();
            if (state.images.isNotEmpty) {
              emit(state.copyWith(selectedImage: state.images[0]));
            }
          case StreamOperation.delete:
        }
      }
    });
  }

  void initializeAlbum() async {
    emit(state.copyWith(loading: true));

    Album updatedAlbum = await dataRepository.getAlbumByID(albumID);

    emit(state.copyWith(album: updatedAlbum, loading: false));

    // Set Internal Ranked Images
    setRankedImages();
    if (state.images.isNotEmpty) {
      emit(state.copyWith(selectedImage: state.images[0]));
    }
  }

  void updateImageInAlbum(String imageID, Photo image) {
    Map<String, Photo> newImageMap = Map.from(state.album.imageMap);
    newImageMap.update(imageID, (value) => image, ifAbsent: () => image);

    Album updatedAlbum = state.album.copyWith(imageMap: newImageMap);

    emit(state.copyWith(album: updatedAlbum));
    setRankedImages();
  }

  void setRankedImages() {
    List<Photo> rankedImages = List.from(state.album.images);
    List<Photo> topThreeImages = [];

    // Set Ranked
    rankedImages.sort((a, b) {
      if (a.upvotes == b.upvotes) {
        return a.uploadDateTime.compareTo(b.uploadDateTime);
      } else {
        return b.upvotes.compareTo(a.upvotes);
      }
    });

    List<Photo> remainingRankedImages = List.from(rankedImages);

    // Set Top Three Images
    if (rankedImages.length > 3) {
      topThreeImages.addAll(rankedImages.getRange(0, 3).toList());
    } else if (rankedImages.isNotEmpty) {
      developer.log("inside top three");
      topThreeImages
          .addAll(rankedImages.getRange(0, rankedImages.length).toList());
      developer.log(rankedImages.length.toString());
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
    PageController miniMapController =
        PageController(initialPage: selectedIndex, viewportFraction: 1 / 6);
    Photo image = state.imageFrameTimelineList[selectedIndex];
    emit(state.copyWith(
      selectedImage: image,
      pageController: pageController,
      miniMapController: miniMapController,
    ));
  }

  void updateImageFrameWithSelectedImage(int selectedIndex,
      {required bool changeMainPage, required bool changeMiniMap}) {
    Photo image = state.imageFrameTimelineList[selectedIndex];
    emit(state.copyWith(selectedImage: image));

    if (changeMainPage) {
      state.pageController.jumpToPage(selectedIndex);
    }

    if (changeMiniMap) {
      state.miniMapController.animateToPage(
        selectedIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.decelerate,
      );
    }
  }

  void nextImage() {
    state.pageController.nextPage(
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  void previousImage() {
    state.pageController.previousPage(
        duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
  }

  void sendInviteToFriends(
      String guestID, String guestFirst, String guestLast) async {
    emit(state.copyWith(loading: true));
    await dataRepository.inviteUserToAlbum(
        state.album.albumId, guestID, guestFirst, guestLast);
    emit(state.copyWith(loading: false));
  }

  @override
  Future<void> close() {
    realtimeRepository.closeAlbumChannelWebSocket();
    imageStreamSubscription.cancel();
    albumStreamSubscription.cancel();
    return super.close();
  }
}
