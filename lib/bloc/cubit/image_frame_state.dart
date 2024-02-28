part of 'image_frame_cubit.dart';

class ImageFrameState extends Equatable {
  final PageController pageController;
  final img.Image selectedImage;
  final Album album;
  final AlbumViewMode viewMode;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];
  final int selectedIndex;
  final bool loading;
  final bool likeLoading;
  final bool upvoteLoading;
  ImageFrameState({
    required this.pageController,
    required this.selectedImage,
    required this.album,
    required this.viewMode,
    required this.selectedIndex,
    this.loading = false,
    this.likeLoading = false,
    this.upvoteLoading = false,
  });

  ImageFrameState copyWith({
    PageController? pageController,
    img.Image? selectedImage,
    Album? album,
    AlbumViewMode? viewMode,
    int? selectedIndex,
    bool? loading,
    bool? likeLoading,
    bool? upvoteLoading,
  }) {
    return ImageFrameState(
      pageController: pageController ?? this.pageController,
      selectedImage: selectedImage ?? this.selectedImage,
      album: album ?? this.album,
      viewMode: viewMode ?? this.viewMode,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      loading: loading ?? this.loading,
      likeLoading: likeLoading ?? this.likeLoading,
      upvoteLoading: upvoteLoading ?? this.upvoteLoading,
    );
  }

  int get filterIndex {
    switch (viewMode) {
      case AlbumViewMode.popular:
        return filterList.indexWhere((element) => element == "Popular");
      case AlbumViewMode.guests:
        return filterList.indexWhere((element) => element == "Guests");
      case AlbumViewMode.timeline:
        return filterList.indexWhere((element) => element == "Timeline");
    }
  }

  List<img.Image> get rankedImageList {
    return album.rankedImages;
  }

  List<img.Image> get guestImageList {
    List<img.Image> ungroupedGuests = [];
    for (List<img.Image> list in album.imagesGroupedByGuest) {
      for (img.Image image in list) {
        ungroupedGuests.add(image);
      }
    }
    return ungroupedGuests;
  }

  List<img.Image> get timelineImageList {
    List<img.Image> ungroupedTimeline = [];
    for (List<img.Image> list in album.imagesGroupedSortedByDate) {
      for (img.Image image in list) {
        ungroupedTimeline.add(image);
      }
    }
    return ungroupedTimeline;
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
        pageController,
        selectedImage,
        album,
        viewMode,
        selectedIndex,
        loading,
        likeLoading,
        upvoteLoading,
      ];
}
