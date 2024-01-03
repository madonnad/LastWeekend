import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/bloc/cubit/new_album_frame_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart' as img;

part 'image_frame_state.dart';

class ImageFrameCubit extends Cubit<ImageFrameState> {
  img.Image image;
  Album album;
  AlbumViewMode viewMode;
  int initialIndex;
  ImageFrameCubit({
    required this.image,
    required this.album,
    required this.viewMode,
    required this.initialIndex,
  }) : super(ImageFrameState(
          pageController: PageController(initialPage: initialIndex),
          selectedImage: image,
          album: album,
          viewMode: viewMode,
          selectedIndex: initialIndex,
        ));

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
