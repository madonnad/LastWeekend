part of 'app_frame_cubit.dart';

class AppFrameState extends Equatable {
  final PageController appFrameController;
  final int pageNumber;
  const AppFrameState({required this.appFrameController, this.pageNumber = 0});

  AppFrameState copyWith({
    PageController? appFrameController,
    int? pageNumber,
  }) {
    return AppFrameState(
      appFrameController: appFrameController ?? this.appFrameController,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [appFrameController, pageNumber];
}
