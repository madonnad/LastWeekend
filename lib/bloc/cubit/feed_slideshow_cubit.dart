import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/models/album.dart';

part 'feed_slideshow_state.dart';

class FeedSlideshowCubit extends Cubit<FeedSlideshowState> {
  final Album album;

  FeedSlideshowCubit({required this.album})
      : super(
          FeedSlideshowState(
            pageController: PageController(),
            album: album,
            avatarUrl: album.rankedImages[0].avatarReq,
          ),
        );

  void updatePage(int index) {
    emit(state.copyWith(
      currentPage: index,
      avatarUrl: album.rankedImages[index].avatarReq,
    ));
  }
}
