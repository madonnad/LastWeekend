part of 'new_album_frame_cubit.dart';

enum AlbumViewMode { popular, guests, timeline }

class NewAlbumFrameState extends Equatable {
  final Album album;
  final AlbumViewMode viewMode;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];

  NewAlbumFrameState({
    required this.album,
    required this.viewMode,
  });

  NewAlbumFrameState copyWith({
    Album? album,
    int? filterIndex,
    AlbumViewMode? viewMode,
  }) {
    return NewAlbumFrameState(
      album: album ?? this.album,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  List<img.Image> get selectedModeImages {
    switch (viewMode) {
      case AlbumViewMode.popular:
        return album.rankedImages;
      case AlbumViewMode.guests:
        List<img.Image> ungroupedGuests = [];
        for (List<img.Image> list in album.imagesGroupedByGuest) {
          for (img.Image image in list) {
            ungroupedGuests.add(image);
          }
        }
        return ungroupedGuests;
      case AlbumViewMode.timeline:
        List<img.Image> ungroupedTimeline = [];
        for (List<img.Image> list in album.imagesGroupedSortedByDate) {
          for (img.Image image in list) {
            ungroupedTimeline.add(image);
          }
        }
        return ungroupedTimeline;
    }
  }

  @override
  List<Object?> get props => [
        album,
        viewMode,
      ];
}
