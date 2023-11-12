part of 'new_app_frame_cubit.dart';

@immutable
class NewAppFrameState extends Equatable {
  final PageController pageController;
  final int index;

  const NewAppFrameState({required this.pageController, this.index = 1});

  NewAppFrameState copyWith({
    PageController? pageController,
    int? index,
  }) {
    return NewAppFrameState(
      pageController: pageController ?? this.pageController,
      index: index ?? this.index,
    );
  }

  @override
  List<Object?> get props => [pageController, index];
}
