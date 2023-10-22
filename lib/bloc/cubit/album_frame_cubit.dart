import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'album_frame_state.dart';

class AlbumFrameCubit extends Cubit<AlbumFrameState> {
  AlbumFrameCubit()
      : super(AlbumFrameState(albumFrameController: PageController()));

  void updatePage(int index) {
    state.albumFrameController.jumpToPage(index);
    emit(
      state.copyWith(
        pageNumber: index,
      ),
    );
  }

  void changeMode(bool mode) {
    if (mode == true) {
      state.albumFrameController.jumpToPage(1);
    }
    if (mode == false) {
      state.albumFrameController.jumpToPage(0);
    }
    emit(state.copyWith(viewMode: mode));
  }
}
