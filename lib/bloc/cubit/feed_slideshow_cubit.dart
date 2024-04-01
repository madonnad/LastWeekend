import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart' as img;
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'feed_slideshow_state.dart';

class FeedSlideshowCubit extends Cubit<FeedSlideshowState> {
  final Album album;
  final DataRepository dataRepository;
  late StreamSubscription imageStreamSubscription;

  FeedSlideshowCubit({required this.album, required this.dataRepository})
      : super(
          FeedSlideshowState(
            pageController: PageController(),
            album: album,
            avatarUrl: album.rankedImages[0].avatarReq,
            imageOwnerName: album.rankedImages[0].fullName,
          ),
        ) {
    Map<String, img.Image> images =
        dataRepository.getAlbumImages(album.albumId);
    album.imageMap = images;

    emit(state.copyWith(album: album));

    imageStreamSubscription = dataRepository.imageStream.listen((event) {
      img.Image newImage = event.image;
      String albumID = event.albumID;
      String imageID = event.imageID;

      if (album.albumId == albumID) {
        updateImageInAlbum(imageID, newImage);
      }
    });
    setTopThreeImages();
  }

  void updateImageInAlbum(String imageID, img.Image image) {
    if (state.album.imageMap.containsKey(imageID)) {
      Album album = Album.from(state.album);
      Map<String, img.Image> newImageMap = Map.from(state.album.imageMap);
      newImageMap[imageID] = image;
      album.imageMap = newImageMap;
      emit(state.copyWith(album: album));
      setTopThreeImages();
    }
  }

  void setTopThreeImages() {
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

    // Set Top Three Images
    if (rankedImages.length > 3) {
      topThreeImages.addAll(rankedImages.getRange(0, 3).toList());
    } else if (rankedImages.isNotEmpty) {
      topThreeImages
          .addAll(rankedImages.getRange(0, rankedImages.length - 1).toList());
    } else {
      topThreeImages = [];
    }

    // Emit Ranked Images
    emit(state.copyWith(
      topThreeImages: topThreeImages,
    ));
  }

  void updatePage(int index) {
    emit(state.copyWith(
      currentPage: index,
      avatarUrl: album.rankedImages[index].avatarReq,
      imageOwnerName: album.rankedImages[index].fullName,
    ));
  }

  @override
  Future<void> close() {
    imageStreamSubscription.cancel();
    return super.close();
  }
}
