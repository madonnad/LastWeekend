part of 'album_frame_cubit.dart';

@immutable
class AlbumFrameState extends Equatable {
  final PageController albumFrameController;
  final int pageNumber;
  const AlbumFrameState(
      {required this.albumFrameController, this.pageNumber = 0});

  AlbumFrameState copyWith({
    PageController? albumFrameController,
    int? pageNumber,
  }) {
    return AlbumFrameState(
      albumFrameController: albumFrameController ?? this.albumFrameController,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [albumFrameController, pageNumber];
}
