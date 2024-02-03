import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/new_album_frame_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/image.dart' as img;
import 'package:shared_photo/repositories/go_repository.dart';

part 'image_frame_state.dart';

class ImageFrameCubit extends Cubit<ImageFrameState> {
  AppBloc appBloc;
  img.Image image;
  Album album;
  AlbumViewMode viewMode;
  int initialIndex;
  GoRepository goRepository;
  ImageFrameCubit({
    required this.appBloc,
    required this.image,
    required this.album,
    required this.viewMode,
    required this.initialIndex,
    required this.goRepository,
  }) : super(
          ImageFrameState(
            uid: appBloc.state.user.id,
            pageController: PageController(initialPage: initialIndex),
            selectedImage: image,
            album: album,
            viewMode: viewMode,
            selectedIndex: initialIndex,
          ),
        ) {
    initializeComments();
  }

  Future<void> initializeComments() async {
    img.Image image = state.selectedImage;

    emit(state.copyWith(loading: true));
    image.comments = await goRepository.getImageComments(image.imageId);
    emit(state.copyWith(loading: false, selectedImage: image));
  }

  Future<void> toggleLike() async {
    img.Image image = state.selectedImage;
    emit(state.copyWith(likeLoading: true));

    if (state.selectedImage.userLiked == true) {
      image.likes = await goRepository.unlikePhoto(
          appBloc.state.user.token, state.selectedImage.imageId);
      image.userLiked = false;
      emit(state.copyWith(likeLoading: false, selectedImage: image));
      return;
    }

    if (state.selectedImage.userLiked == false) {
      image.likes = await goRepository.likePhoto(
          appBloc.state.user.token, state.selectedImage.imageId);
      image.userLiked = true;
      emit(state.copyWith(likeLoading: false, selectedImage: image));
      return;
    }
  }

  Future<void> toggleUpvote() async {
    img.Image image = state.selectedImage;
    emit(state.copyWith(upvoteLoading: true));

    if (state.selectedImage.userUpvoted == true) {
      image.upvotes = await goRepository.removeUpvoteFromPhoto(
          appBloc.state.user.token, state.selectedImage.imageId);
      image.userUpvoted = false;
      emit(state.copyWith(upvoteLoading: false, selectedImage: image));
      return;
    }

    if (state.selectedImage.userUpvoted == false) {
      image.upvotes = await goRepository.upvotePhoto(
          appBloc.state.user.token, state.selectedImage.imageId);
      image.userUpvoted = true;
      emit(state.copyWith(upvoteLoading: false, selectedImage: image));
      return;
    }
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
