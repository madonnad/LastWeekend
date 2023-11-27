part of 'new_album_frame_cubit.dart';

@immutable
class NewAlbumFrameState {
  final List<String> filterList = ["Popular", "Guests", "Timeline"];
  final int filterIndex;

  NewAlbumFrameState({required this.filterIndex});

  NewAlbumFrameState copyWith({int? filterIndex}) {
    return NewAlbumFrameState(filterIndex: filterIndex ?? this.filterIndex);
  }
}
