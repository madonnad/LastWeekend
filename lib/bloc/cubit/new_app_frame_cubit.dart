import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

part 'new_app_frame_state.dart';

class NewAppFrameCubit extends Cubit<NewAppFrameState> {
  NewAppFrameCubit()
      : super(NewAppFrameState(pageController: PageController(initialPage: 1)));

  void changePage(int index) {
    state.pageController.jumpToPage(index);
    HapticFeedback.mediumImpact();
    emit(state.copyWith(index: index));
  }
}
