part of 'new_album_frame_cubit.dart';

@immutable
class NewAlbumFrameState {
  final Album album;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];
  final int filterIndex;

  NewAlbumFrameState({required this.filterIndex, required this.album});

  NewAlbumFrameState copyWith({
    Album? album,
    int? filterIndex,
  }) {
    return NewAlbumFrameState(
      album: album ?? this.album,
      filterIndex: filterIndex ?? this.filterIndex,
    );
  }
}
