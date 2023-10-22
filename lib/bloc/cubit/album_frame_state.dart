part of 'album_frame_cubit.dart';

@immutable
class AlbumFrameState extends Equatable {
  final PageController albumFrameController;
  final int pageNumber;
  final bool viewMode;
  const AlbumFrameState({
    required this.albumFrameController,
    this.pageNumber = 0,
    this.viewMode = true,
  });

  AlbumFrameState copyWith({
    PageController? albumFrameController,
    int? pageNumber,
    bool? viewMode,
  }) {
    return AlbumFrameState(
        albumFrameController: albumFrameController ?? this.albumFrameController,
        pageNumber: pageNumber ?? this.pageNumber,
        viewMode: viewMode ?? this.viewMode);
  }

  @override
  List<Object> get props => [albumFrameController, pageNumber, viewMode];
}
