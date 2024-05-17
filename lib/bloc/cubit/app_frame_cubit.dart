import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

part 'app_frame_state.dart';

class AppFrameCubit extends Cubit<AppFrameState> {
  AppFrameCubit()
      : super(AppFrameState(pageController: PageController(initialPage: 1)));

  void changePage(int index) {
    state.pageController.jumpToPage(index);
    HapticFeedback.mediumImpact();
    emit(state.copyWith(index: index));
  }

  // void changePageFromPassedRoute(BuildContext context, int index) {
  //   Navigator.of(context).
  //   state.pageController.jumpToPage(index);
  // }
}
