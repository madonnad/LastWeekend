part of 'app_frame_cubit.dart';

@immutable
class AppFrameState extends Equatable {
  final PageController pageController;
  final int index;

  const AppFrameState({required this.pageController, this.index = 1});

  AppFrameState copyWith({
    PageController? pageController,
    int? index,
  }) {
    return AppFrameState(
      pageController: pageController ?? this.pageController,
      index: index ?? this.index,
    );
  }

  @override
  List<Object?> get props => [pageController, index];
}
