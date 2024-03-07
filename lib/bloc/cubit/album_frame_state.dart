part of 'album_frame_cubit.dart';

enum AlbumViewMode { popular, guests, timeline }

class AlbumFrameState extends Equatable {
  final Album album;
  final PageController pageController;
  final img.Image? selectedImage;
  final List<img.Image> rankedImages;
  final List<img.Image> topThreeImages;
  final List<img.Image> remainingRankedImages;
  final AlbumViewMode viewMode;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];

  AlbumFrameState({
    required this.album,
    required this.pageController,
    this.selectedImage,
    this.rankedImages = const [],
    this.topThreeImages = const [],
    this.remainingRankedImages = const [],
    required this.viewMode,
  });

  AlbumFrameState copyWith({
    Album? album,
    PageController? pageController,
    img.Image? selectedImage,
    List<img.Image>? rankedImages,
    List<img.Image>? topThreeImages,
    List<img.Image>? remainingRankedImages,
    AlbumViewMode? viewMode,
  }) {
    return AlbumFrameState(
      album: album ?? this.album,
      pageController: pageController ?? this.pageController,
      selectedImage: selectedImage ?? this.selectedImage,
      rankedImages: rankedImages ?? this.rankedImages,
      topThreeImages: topThreeImages ?? this.topThreeImages,
      remainingRankedImages:
          remainingRankedImages ?? this.remainingRankedImages,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  List<img.Image> get selectedModeImages {
    switch (viewMode) {
      case AlbumViewMode.popular:
        return rankedImages;
      case AlbumViewMode.guests:
        List<img.Image> ungroupedGuests = [];
        for (List<img.Image> list in imagesGroupedByGuest) {
          for (img.Image image in list) {
            ungroupedGuests.add(image);
          }
        }
        return ungroupedGuests;
      case AlbumViewMode.timeline:
        List<img.Image> ungroupedTimeline = [];
        for (List<img.Image> list in imagesGroupedSortedByDate) {
          for (img.Image image in list) {
            ungroupedTimeline.add(image);
          }
        }
        return ungroupedTimeline;
    }
  }

  List<img.Image> get images {
    return album.imageMap.values.toList();
  }

  List<List<img.Image>> get imagesGroupedByGuest {
    Map<String, List<img.Image>> mapImages = {};
    List<List<img.Image>> listImages = [];

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

  List<List<img.Image>> get imagesGroupedSortedByDate {
    Map<String, List<img.Image>> mapImages = {};
    List<List<img.Image>> listImages = [];

    for (var item in images) {
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

  List<img.Image> get imageFrameTimelineList {
    List<img.Image> ungroupedTimeline = [];
    for (List<img.Image> list in imagesGroupedSortedByDate) {
      for (img.Image image in list) {
        ungroupedTimeline.add(image);
      }
    }
    return ungroupedTimeline;
  }

  @override
  List<Object?> get props => [
        album,
        pageController,
        selectedImage,
        rankedImages,
        topThreeImages,
        remainingRankedImages,
        viewMode,
      ];
}
