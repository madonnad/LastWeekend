import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'app_frame_state.dart';

class AppFrameCubit extends Cubit<AppFrameState> {
  AppFrameCubit() : super(AppFrameState(appFrameController: PageController()));

  void updatePage(int index) {
    state.appFrameController.jumpToPage(index);
    emit(
      state.copyWith(
        pageNumber: index,
      ),
    );
  }
}
