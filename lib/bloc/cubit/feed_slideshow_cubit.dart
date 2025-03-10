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
  late StreamSubscription albumStreamSubscription;

  FeedSlideshowCubit({required this.album, required this.dataRepository})
      : super(
          FeedSlideshowState(
            album: album,
            avatarUrl: album.rankedImages.isNotEmpty
                ? album.rankedImages[0].avatarReq
                : album.ownerImageURl,
            imageOwnerName: album.rankedImages.isNotEmpty
                ? album.rankedImages[0].fullName
                : album.fullName,
          ),
        ) {
    setAlbumImagesFromRepo();

    imageStreamSubscription = dataRepository.imageStream.listen((event) {
      if (event.albumID == album.albumId) {
        updateImageInAlbum(event.imageID, event.image);
      }
    });

    albumStreamSubscription = dataRepository.albumStream.listen((event) {
      StreamOperation operation = event.$1;
      Album album = event.$2;

      switch (operation) {
        case StreamOperation.add:
        case StreamOperation.update:
          setAlbumImagesFromStream(album);
        case StreamOperation.delete:
      }
    });
  }

  void updateImageInAlbum(String imageID, Photo image) {
    Map<String, Photo> newImageMap = Map.from(state.album.imageMap);
    newImageMap.update(imageID, (value) => image, ifAbsent: () => image);

    Album updatedAlbum = state.album.copyWith(imageMap: newImageMap);

    emit(state.copyWith(album: updatedAlbum));

    setTopThreeImages();
  }

  Future<void> setAlbumImagesFromRepo() async {
    Map<String, Photo> images =
        await dataRepository.getAlbumImages(album.albumId);
    //album.imageMap = images;
    Album newAlbum = album.copyWith(imageMap: images);

    if (super.isClosed) {
      return;
    }
    emit(state.copyWith(album: newAlbum));

    setTopThreeImages();
  }

  void setAlbumImagesFromStream(Album album) {
    if (super.isClosed) {
      return;
    }
    emit(state.copyWith(album: album));

    setTopThreeImages();
  }

  void setTopThreeImages() {
    List<Photo> rankedImages = List.from(state.album.images);
    List<Photo> topThreeImages = [];

    // Set Ranked
    rankedImages.sort((a, b) {
      if (a.upvotes == b.upvotes) {
        return a.capturedDatetime.compareTo(b.capturedDatetime);
      } else {
        return b.upvotes.compareTo(a.upvotes);
      }
    });

    // Set Top Three Images
    if (rankedImages.length > 3) {
      topThreeImages.addAll(rankedImages.getRange(0, 3).toList());
    } else if (rankedImages.isNotEmpty) {
      topThreeImages
          .addAll(rankedImages.getRange(0, rankedImages.length).toList());
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
    albumStreamSubscription.cancel();
    return super.close();
  }
}
