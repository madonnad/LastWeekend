import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart' as img;
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'image_frame_state.dart';

class ImageFrameCubit extends Cubit<ImageFrameState> {
  DataRepository dataRepository;
  img.Image image;
  Album album;
  AlbumViewMode viewMode;
  int initialIndex;
  ImageFrameCubit({
    required this.dataRepository,
    required this.image,
    required this.album,
    required this.viewMode,
    required this.initialIndex,
  }) : super(
          ImageFrameState(
            pageController: PageController(initialPage: initialIndex),
            selectedImage: image,
            album: album,
            viewMode: viewMode,
            selectedIndex: initialIndex,
          ),
        ) {
    initializeComments();

    dataRepository.imageStream.listen((event) {});
  }

  Future<void> initializeComments() async {
    img.Image image = state.selectedImage;

    emit(state.copyWith(loading: true));

    image.commentMap = await dataRepository.initalizeCommentsAndStore(
        album.albumId, image.imageId);

    emit(state.copyWith(loading: false, selectedImage: image));
  }

  Future<void> toggleLike() async {
    img.Image image = state.selectedImage;

    emit(state.copyWith(likeLoading: true));

    late bool userLiked;
    late int count;

    (userLiked, count) = await dataRepository.toggleImageLike(
        album.albumId, image.imageId, image.userLiked);

    image.userLiked = userLiked;
    image.likes = count;

    emit(state.copyWith(likeLoading: false, selectedImage: image));
  }

  Future<void> toggleUpvote() async {
    img.Image image = state.selectedImage;

    emit(state.copyWith(upvoteLoading: true));

    late bool userUpvoted;
    late int count;

    (userUpvoted, count) = await dataRepository.toggleImageUpvote(
        album.albumId, image.imageId, image.userUpvoted);

    image.userUpvoted = userUpvoted;
    image.upvotes = count;

    emit(state.copyWith(upvoteLoading: false, selectedImage: image));
  }

  void changeViewMode(String? selection) {
    switch (selection) {
      case "Popular":
        int newIndex = state.rankedImageList.indexOf(state.selectedImage);
        emit(state.copyWith(viewMode: AlbumViewMode.popular));
        state.pageController.jumpToPage(newIndex);
      case "Guests":
        int newIndex = state.guestImageList.indexOf(state.selectedImage);
        emit(state.copyWith(viewMode: AlbumViewMode.guests));
        state.pageController.jumpToPage(newIndex);
      case "Timeline":
        int newIndex = state.timelineImageList.indexOf(state.selectedImage);
        emit(state.copyWith(
          viewMode: AlbumViewMode.timeline,
        ));
        state.pageController.jumpToPage(newIndex);
    }
  }

  void imageChange(index) {
    img.Image newImage = state.selectedModeImages[index];
    emit(state.copyWith(selectedImage: newImage));
    initializeComments();
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
