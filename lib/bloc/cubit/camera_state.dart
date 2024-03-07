part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final List<CapturedImage> photosTaken;
  final List<CapturedImage> uploadList;
  final int? selectedIndex;
  final CapturedImage? selectedImage;
  //final List<Album> unlockedAlbums;
  final Map<String, Album> unlockedAlbumMap;
  final Album? selectedAlbum;
  final TextEditingController captionTextController;
  final bool loading;
  const CameraState({
    required this.photosTaken,
    required this.uploadList,
    required this.selectedIndex,
    required this.selectedImage,
    //required this.unlockedAlbums,
    required this.unlockedAlbumMap,
    required this.selectedAlbum,
    required this.captionTextController,
    required this.loading,
  });

  factory CameraState.empty() {
    return CameraState(
      photosTaken: const [],
      uploadList: const [],
      selectedIndex: null,
      selectedImage: null,
      selectedAlbum: null,
      //unlockedAlbums: const [],
      unlockedAlbumMap: HashMap(),
      captionTextController: TextEditingController(),
      loading: false,
    );
  }

  CameraState copyWith({
    List<CapturedImage>? photosTaken,
    List<CapturedImage>? uploadList,
    int? selectedIndex,
    CapturedImage? selectedImage,
    //List<Album>? unlockedAlbums,
    Map<String, Album>? unlockedAlbumMap,
    Album? selectedAlbum,
    TextEditingController? captionTextController,
    bool? loading,
  }) {
    return CameraState(
      photosTaken: photosTaken ?? this.photosTaken,
      uploadList: uploadList ?? this.uploadList,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedImage: selectedImage ?? this.selectedImage,
      selectedAlbum: selectedAlbum ?? this.selectedAlbum,
      //unlockedAlbums: unlockedAlbums ?? this.unlockedAlbums,
      unlockedAlbumMap: unlockedAlbumMap ?? this.unlockedAlbumMap,
      captionTextController:
          captionTextController ?? this.captionTextController,
      loading: loading ?? this.loading,
    );
  }

  List<CapturedImage> get selectedAlbumImageList {
    return List.from(
        photosTaken.where((element) => element.album == selectedAlbum));
  }

  List<Album> get unlockedAlbums {
    return unlockedAlbumMap.values.toList();
  }

  Map<Album, List<CapturedImage>> get mapOfAlbumImages {
    Map<Album, List<CapturedImage>> mapOfAlbImg = {};

    for (CapturedImage image in photosTaken) {
      if (image.album != null) {
        mapOfAlbImg
            .putIfAbsent(image.album!, () => <CapturedImage>[])
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
        uploadList,
        selectedIndex,
        selectedAlbum,
        //unlockedAlbums,
        unlockedAlbumMap,
        selectedImage,
        selectedImageRecap,
        captionTextController,
        loading,
      ];
}
