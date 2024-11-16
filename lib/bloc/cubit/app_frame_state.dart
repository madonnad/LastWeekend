part of 'app_frame_cubit.dart';

@immutable
class AppFrameState extends Equatable {
  final PageController pageController;
  final ScrollController feedScrollController;
  final int index;

  const AppFrameState({
    required this.pageController,
    required this.feedScrollController,
    this.index = 1,
  });

  AppFrameState copyWith({
    PageController? pageController,
    ScrollController? feedScrollController,
    int? index,
  }) {
    return AppFrameState(
      pageController: pageController ?? this.pageController,
      feedScrollController: feedScrollController ?? this.feedScrollController,
      index: index ?? this.index,
    );
  }

  @override
  List<Object?> get props => [pageController, feedScrollController, index];
}
