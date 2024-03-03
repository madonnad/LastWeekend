part of 'album_frame_cubit.dart';

enum AlbumViewMode { popular, guests, timeline }

class AlbumFrameState extends Equatable {
  final Album album;
  final Map<String, Image> imageMap;
  final AlbumViewMode viewMode;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];

  AlbumFrameState({
    required this.album,
    this.imageMap = const {},
    required this.viewMode,
  });

  AlbumFrameState copyWith({
    Album? album,
    Map<String, Image>? imageMap,
    int? filterIndex,
    AlbumViewMode? viewMode,
  }) {
    return AlbumFrameState(
      album: album ?? this.album,
      imageMap: imageMap ?? this.imageMap,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  List<Image> get selectedModeImages {
    switch (viewMode) {
      case AlbumViewMode.popular:
        return rankedImages;
      case AlbumViewMode.guests:
        List<Image> ungroupedGuests = [];
        for (List<Image> list in imagesGroupedByGuest) {
          for (Image image in list) {
            ungroupedGuests.add(image);
          }
        }
        return ungroupedGuests;
      case AlbumViewMode.timeline:
        List<Image> ungroupedTimeline = [];
        for (List<Image> list in imagesGroupedSortedByDate) {
          for (Image image in list) {
            ungroupedTimeline.add(image);
          }
        }
        return ungroupedTimeline;
    }
  }

  List<Image> get images {
    return imageMap.values.toList();
  }

  List<Image> get rankedImages {
    List<Image> rankedImages = List.from(images);
    rankedImages.sort((a, b) => b.upvotes.compareTo(a.upvotes));

    return rankedImages;
  }

  List<Image> get topThreeImages {
    List<Image> images = List.from(rankedImages);
    if (rankedImages.length > 3) {
      return images.getRange(0, 3).toList();
    } else if (rankedImages.isNotEmpty) {
      return rankedImages.getRange(0, images.length - 1).toList();
    } else {
      return [];
    }
  }

  List<Image> get remainingRankedImages {
    List<Image> images = List.from(rankedImages);
    if (rankedImages.length > 3) {
      images.removeRange(0, 3);
      return images;
    } else {
      return [];
    }
  }

  List<List<Image>> get imagesGroupedByGuest {
    Map<String, List<Image>> mapImages = {};
    List<List<Image>> listImages = [];

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

  List<List<Image>> get imagesGroupedSortedByDate {
    Map<String, List<Image>> mapImages = {};
    List<List<Image>> listImages = [];

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

  @override
  List<Object?> get props => [
        album,
        imageMap,
        viewMode,
      ];
}
