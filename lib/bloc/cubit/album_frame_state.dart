part of 'album_frame_cubit.dart';

enum AlbumViewMode { popular, guests, timeline }

class AlbumFrameState extends Equatable {
  final Album album;
  final PageController pageController;
  final PageController miniMapController;
  final Photo? selectedImage;
  final List<Photo> rankedImages;
  final List<Photo> topThreeImages;
  final List<Photo> remainingRankedImages;
  final AlbumViewMode viewMode;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];
  final bool loading;
  final CustomException exception;

  AlbumFrameState({
    required this.album,
    required this.pageController,
    required this.miniMapController,
    this.selectedImage,
    this.rankedImages = const [],
    this.topThreeImages = const [],
    this.remainingRankedImages = const [],
    required this.viewMode,
    this.loading = false,
    this.exception = CustomException.empty,
  });

  AlbumFrameState copyWith({
    Album? album,
    PageController? pageController,
    PageController? miniMapController,
    Photo? selectedImage,
    List<Photo>? rankedImages,
    List<Photo>? topThreeImages,
    List<Photo>? remainingRankedImages,
    AlbumViewMode? viewMode,
    bool? loading,
    CustomException? exception,
  }) {
    return AlbumFrameState(
      album: album ?? this.album,
      pageController: pageController ?? this.pageController,
      miniMapController: miniMapController ?? this.miniMapController,
      selectedImage: selectedImage ?? this.selectedImage,
      rankedImages: rankedImages ?? this.rankedImages,
      topThreeImages: topThreeImages ?? this.topThreeImages,
      remainingRankedImages:
          remainingRankedImages ?? this.remainingRankedImages,
      viewMode: viewMode ?? this.viewMode,
      loading: loading ?? this.loading,
      exception: exception ?? this.exception,
    );
  }

  List<Photo> get selectedModeImages {
    switch (viewMode) {
      case AlbumViewMode.popular:
        return rankedImages;
      case AlbumViewMode.guests:
        List<Photo> ungroupedGuests = [];
        for (List<Photo> list in imagesGroupedByGuest) {
          for (Photo image in list) {
            ungroupedGuests.add(image);
          }
        }
        return ungroupedGuests;
      case AlbumViewMode.timeline:
        List<Photo> ungroupedTimeline = [];
        for (List<Photo> list in imagesGroupedSortedByDate) {
          for (Photo image in list) {
            ungroupedTimeline.add(image);
          }
        }
        return ungroupedTimeline;
    }
  }

  List<Photo> get images {
    return album.imageMap.values.toList();
  }

  List<List<Photo>> get imagesGroupedByGuest {
    Map<String, List<Photo>> mapImages = {};
    List<List<Photo>> listImages = [];

    for (var item in images) {
      if (!mapImages.containsKey(item.owner)) {
        mapImages[item.owner] = [];
      }
      if (mapImages[item.owner] != null) {
        mapImages[item.owner]!.add(item);
      }
    }

    mapImages.forEach((key, value) {
      value.sort((a, b) => b.upvotes.compareTo(a.upvotes));
    });

    mapImages.forEach((key, value) {
      listImages.add(value);
    });

    return listImages;
  }

  List<List<Photo>> get imagesGroupedSortedByDate {
    Map<String, List<Photo>> mapImages = {};
    List<List<Photo>> listImages = [];
    List<Photo> dateSortedImages = images;

    dateSortedImages
        .sort((a, b) => a.uploadDateTime.compareTo(b.uploadDateTime));

    for (var item in dateSortedImages) {
      if (!mapImages.containsKey(item.dateString)) {
        mapImages[item.dateString] = [];
      }
      if (mapImages[item.dateString] != null) {
        mapImages[item.dateString]!.add(item);
      }
    }

    mapImages.forEach((key, value) {
      value.sort((a, b) => a.uploadDateTime.compareTo(b.uploadDateTime));
    });

    mapImages.forEach((key, value) {
      listImages.add(value);
    });

    return listImages;
  }

  List<Photo> get imageFrameTimelineList {
    List<Photo> ungroupedTimeline = [];
    for (List<Photo> list in imagesGroupedSortedByDate) {
      for (Photo image in list) {
        ungroupedTimeline.add(image);
      }
    }
    return ungroupedTimeline;
  }

  @override
  List<Object?> get props => [
        album,
        pageController,
        miniMapController,
        selectedImage,
        rankedImages,
        topThreeImages,
        remainingRankedImages,
        viewMode,
        loading,
        exception,
      ];
}
