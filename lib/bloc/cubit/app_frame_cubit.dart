import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_photo/repositories/notification_repository/notification_repository.dart';

part 'app_frame_state.dart';

class AppFrameCubit extends Cubit<AppFrameState> {
  NotificationRepository notificationRepository;
  late StreamSubscription navigationController;

  AppFrameCubit({required this.notificationRepository})
      : super(AppFrameState(
          pageController: PageController(initialPage: 1),
          feedScrollController: ScrollController(),
        )) {
    navigationController =
        notificationRepository.navigationStream.listen((data) {
      switch (data) {
        case "album-invite":
          state.pageController.jumpToPage(3);
          emit(state.copyWith(index: 3));
        case "friend-request":
          state.pageController.jumpToPage(3);
          emit(state.copyWith(index: 3));
        default:
      }
    });
  }

  void changePage(int index) {
    state.pageController.jumpToPage(index);
    HapticFeedback.mediumImpact();
    emit(state.copyWith(index: index));
  }

  void jumpToTopOfFeed() {
    if (state.index != 1) {
      return;
    }
    state.feedScrollController.animateTo(
      0,
      duration: Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Future<void> close() {
    navigationController.cancel();
    return super.close();
  }
}
