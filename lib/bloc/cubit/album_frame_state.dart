part of 'album_frame_cubit.dart';

class AlbumFrameState extends Equatable {
  final Album album;
  final List<Photo> images;
  final Photo? selectedImage;
  final List<Photo> rankedImages;
  final bool loading;
  final CustomException exception;

  const AlbumFrameState({
    required this.album,
    this.images = const [],
    this.selectedImage,
    this.rankedImages = const [],
    this.loading = false,
    this.exception = CustomException.empty,
  });

  AlbumFrameState copyWith({
    Album? album,
    List<Photo>? images,
    Photo? selectedImage,
    List<Photo>? rankedImages,
    bool? loading,
    CustomException? exception,
    bool clearSelectedImage = false,
  }) {
    return AlbumFrameState(
      album: album ?? this.album,
      images: images ?? this.images,
      selectedImage:
          clearSelectedImage ? null : (selectedImage ?? this.selectedImage),
      rankedImages: rankedImages ?? this.rankedImages,
      loading: loading ?? this.loading,
      exception: exception ?? this.exception,
    );
  }

  List<Guest> get mostImagesUploaded {
    Map<Guest, List<Photo>> mapImages = {};

    for (var guest in album.guests) {
      mapImages[guest] = [];
    }

    for (var item in images) {
      Guest _guest =
          album.guests.firstWhere((guest) => guest.uid == item.owner);
      if (!mapImages.containsKey(_guest)) {
        mapImages[_guest] = [];
      }
      if (mapImages[_guest] != null) {
        mapImages[_guest]!.add(item);
      }
    }

    List<Guest> sortedGuests = mapImages.keys.toList()
      ..sort((a, b) => mapImages[b]!.length.compareTo(mapImages[a]!.length));

    return sortedGuests;
  }

  Map<String, List<Photo>> get imagesGroupedByGuest {
    Map<String, List<Photo>> mapImages = {};

    for (var guest in album.guests) {
      mapImages[guest.uid] = [];
    }

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

    var sortedEntries = mapImages.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    // Return a LinkedHashMap to preserve the order
    return LinkedHashMap.fromEntries(sortedEntries);
  }

  List<Photo> get popularPhotoSlider {
    List<Photo> popular = rankedImages;
    return popular.take(10).toList();
  }

  List<List<Photo>> get imagesGroupedSortedByDate {
    Map<String, List<Photo>> mapImages = {};
    List<List<Photo>> listImages = [];
    List<Photo> dateSortedImages = List.from(images);
    List<Photo> forgotImages = List.from(images);

    dateSortedImages.removeWhere((test) => test.type == UploadType.forgotShot);
    forgotImages.removeWhere((test) => test.type == UploadType.snap);

    forgotImages
        .sort((a, b) => a.capturedDatetime.compareTo(b.capturedDatetime));

    dateSortedImages
        .sort((a, b) => a.capturedDatetime.compareTo(b.capturedDatetime));

    for (var item in dateSortedImages) {
      if (!mapImages.containsKey(item.dateString)) {
        mapImages[item.dateString] = [];
      }
      if (mapImages[item.dateString] != null) {
        mapImages[item.dateString]!.add(item);
      }
    }

    mapImages.forEach((key, value) {
      value.sort((a, b) => a.capturedDatetime.compareTo(b.capturedDatetime));
    });

    mapImages.forEach((key, value) {
      listImages.add(value);
    });

    listImages.add(forgotImages);

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
        images,
        selectedImage,
        rankedImages,
        loading,
        exception,
      ];
}
