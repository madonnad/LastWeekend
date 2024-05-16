import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'feed_slideshow_state.dart';

class FeedSlideshowCubit extends Cubit<FeedSlideshowState> {
  final Album album;
  final DataRepository dataRepository;
  late StreamSubscription imageStreamSubscription;
  //late Timer _timer;

  FeedSlideshowCubit({required this.album, required this.dataRepository})
      : super(
          FeedSlideshowState(
            pageController: PageController(),
            album: album,
            avatarUrl: album.rankedImages[0].avatarReq,
            imageOwnerName: album.rankedImages[0].fullName,
          ),
        ) {
    setAlbumImages();

    imageStreamSubscription = dataRepository.imageStream.listen((event) {
      if (event.albumID == album.albumId) {
        updateImageInAlbum(event.imageID, event.image);
      }
    });

    // _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
    //   setAlbumImages();
    // });
  }

  void updateImageInAlbum(String imageID, Photo image) {
    Map<String, Photo> newImageMap = Map.from(state.album.imageMap);
    newImageMap.update(imageID, (value) => image, ifAbsent: () => image);

    Album updatedAlbum = state.album.copyWith(imageMap: newImageMap);

    emit(state.copyWith(album: updatedAlbum));

    setTopThreeImages();
  }

  Future<void> setAlbumImages() async {
    Map<String, Photo> images =
        await dataRepository.getAlbumImages(album.albumId);
    //album.imageMap = images;
    Album newAlbum = album.copyWith(imageMap: images);

    emit(state.copyWith(album: newAlbum));

    setTopThreeImages();
  }

  void setTopThreeImages() {
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
    //_timer.cancel();
    imageStreamSubscription.cancel();
    return super.close();
  }
}
