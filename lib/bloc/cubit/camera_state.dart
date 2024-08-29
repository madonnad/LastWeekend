part of 'camera_cubit.dart';

enum UploadMode { unlockedAlbums, singleAlbum }

class CameraState extends Equatable {
  final List<CapturedImage> photosTaken;
  final List<CapturedImage> photosToggled;
  final Map<String, CapturedImage> failedUploads;
  final int? selectedIndex;
  final CapturedImage? selectedImage;
  final Map<String, Album> albumMap;
  final Album? selectedAlbum;
  final TextEditingController captionTextController;
  final bool loading;
  final UploadMode mode;
  final CustomException exception;
  const CameraState({
    required this.photosTaken,
    required this.photosToggled,
    required this.failedUploads,
    required this.selectedIndex,
    required this.selectedImage,
    required this.albumMap,
    required this.selectedAlbum,
    required this.captionTextController,
    required this.loading,
    required this.mode,
    this.exception = CustomException.empty,
  });

  factory CameraState.empty() {
    return CameraState(
      photosTaken: const [],
      photosToggled: const [],
      failedUploads: const {},
      selectedIndex: null,
      selectedImage: null,
      selectedAlbum: null,
      albumMap: HashMap(),
      captionTextController: TextEditingController(),
      loading: false,
      mode: UploadMode.unlockedAlbums,
    );
  }

  CameraState copyWith({
    List<CapturedImage>? photosTaken,
    List<CapturedImage>? photosToggled,
    Map<String, CapturedImage>? failedUploads,
    int? selectedIndex,
    CapturedImage? selectedImage,
    Map<String, Album>? albumMap,
    Album? selectedAlbum,
    TextEditingController? captionTextController,
    bool? loading,
    UploadMode? mode,
    CustomException? exception,
  }) {
    return CameraState(
      photosTaken: photosTaken ?? this.photosTaken,
      photosToggled: photosToggled ?? this.photosToggled,
      failedUploads: failedUploads ?? this.failedUploads,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedAlbum: selectedAlbum ?? this.selectedAlbum,
      albumMap: albumMap ?? this.albumMap,
      captionTextController:
          captionTextController ?? this.captionTextController,
      loading: loading ?? this.loading,
      mode: mode ?? this.mode,
      exception: exception ?? this.exception,
    );
  }

  List<CapturedImage> get selectedAlbumImageList {
    return List.from(photosTaken
        .where((element) => element.albumID == selectedAlbum!.albumId));
  }

  List<CapturedImage> get selectedAlbumToggleImageList {
    return List.from(photosToggled
        .where((element) => element.albumID == selectedAlbum!.albumId));
  }

  List<Album> get unlockedAlbums {
    return albumMap.values.toList();
  }

  int get selectedAlbumIndex {
    if (selectedAlbum != null) {
      return unlockedAlbums
          .indexWhere((element) => element.albumId == selectedAlbum!.albumId);
    }
    return 0;
  }

  Map<String, List<CapturedImage>> get mapOfAlbumImages {
    Map<String, List<CapturedImage>> mapOfAlbImg = {};

    for (CapturedImage image in photosTaken) {
      if (image.albumID != null) {
        mapOfAlbImg
            .putIfAbsent(image.albumID!, () => <CapturedImage>[])
            .add(image);
      }
    }
    return mapOfAlbImg;
  }

  bool get selectedImageRecap {
    if (selectedImage != null) {
      return selectedImage!.addToRecap;
    }
    return false;
  }

  @override
  List<Object?> get props => [
        photosTaken,
        photosToggled,
        failedUploads,
        selectedIndex,
        selectedAlbum,
        albumMap,
        selectedImage,
        selectedImageRecap,
        captionTextController,
        loading,
        mode,
        exception,
      ];
}
