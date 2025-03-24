import 'dart:async';
import 'dart:collection';
import 'dart:io' show Platform;

import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/custom_exception.dart';
import 'package:shared_photo/models/guest.dart';
import 'package:shared_photo/models/notification.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'camera_state.dart';

class CameraCubit extends HydratedCubit<CameraState> {
  DataRepository dataRepository;
  User user;
  UploadMode mode;
  Album? album;
  late StreamSubscription? albumStreamSubscription;
  FirebaseAnalytics instance = FirebaseAnalytics.instance;

  CameraCubit(
      {required this.dataRepository,
      required this.user,
      required this.mode,
      this.album})
      : super(CameraState.empty()) {
    if (mode == UploadMode.unlockedAlbums) {
      //hydrate(); No longer need to call this on the HydratedCubit
      checkFailedUploads();
      albumStreamSubscription = dataRepository.albumStream.listen((event) {
        StreamOperation streamOperation = event.$1;
        Album album = event.$2;

        // Check if user is in the album that was passed
        bool userIsGuest = false;

        for (Guest guest in album.guests) {
          if (guest.uid == user.id && guest.status == RequestStatus.accepted) {
            userIsGuest = true;
          }
        }

        bool userIsOwner = album.albumOwner == user.id;

        // Only allow album through if it passes these qualities
        if ((userIsGuest || userIsOwner) && album.phase == AlbumPhases.open) {
          switch (streamOperation) {
            case StreamOperation.add:
              addUnlockedAlbums(album);
            case StreamOperation.update:
            case StreamOperation.delete:
              removeEventFromList(album);
          }
        }
      });
      // Initialize Unlocked Album Map
      _initializeUnlockedAlbums();
    } else if (mode == UploadMode.singleAlbum) {
      albumStreamSubscription = null;
      if (album != null) {
        Map<String, Album> albumMap = {album!.albumId: album!};
        emit(state.copyWith(
          albumMap: albumMap,
          selectedAlbum: album!,
          mode: mode,
        ));
      }
    }
  }

  void _initializeUnlockedAlbums() {
    Map<String, Album> unlockedMap = Map.from(dataRepository.unlockedAlbums());
    Album? selectedAlbum;
    if (unlockedMap.isNotEmpty) {
      selectedAlbum = unlockedMap.values.toList()[0];
    }

    emit(state.copyWith(albumMap: unlockedMap, selectedAlbum: selectedAlbum));
  }

  void checkFailedUploads() async {
    if (state.failedUploads.isEmpty) return;

    int backoffTime = 0;
    int backoffIterator = 1;

    Map<String, CapturedImage> failedUploads = Map.from(state.failedUploads);

    while (failedUploads.isNotEmpty) {
      for (CapturedImage image in state.failedUploads.values.toList()) {
        bool success = false;
        //String? error;
        (success, _) = await dataRepository.uploadFailedImage(image);
        if (success) {
          failedUploads.removeWhere((key, value) => key == image.uuid);
          emit(state.copyWith(failedUploads: failedUploads));
        } else {
          backoffTime = 2 ^ backoffIterator;
          await Future.delayed(Duration(seconds: backoffTime));
          backoffIterator++;
          if (backoffIterator > 7) return;
        }
      }
    }
  }

  void addUnlockedAlbums(Album album) {
    Map<String, Album> albumMap = Map.from(state.albumMap);

    String key = album.albumId;

    if (!albumMap.containsKey(key) || albumMap[key] != album) {
      albumMap[key] = album;

      if (albumMap.length == 1) {
        emit(state.copyWith(
            albumMap: albumMap, selectedAlbum: albumMap.entries.first.value));
        return;
      }
      emit(state.copyWith(albumMap: albumMap));
    }
  }

  void removeEventFromList(Album album) {
    Map<String, Album> albumMap = Map.from(state.albumMap);

    albumMap.remove(album.albumId);

    emit(state.copyWith(albumMap: albumMap));
  }

  void toggleImageInUploadList(CapturedImage image) {
    List<CapturedImage> imageList = List.from(state.photosToggled);
    if (imageList.contains(image)) {
      imageList.removeWhere((listImage) => listImage == image);
    } else {
      imageList.add(image);
    }
    emit(state.copyWith(photosToggled: imageList));
  }

  Future<void> downloadImageToDevice() async {
    if (state.selectedImage?.imageXFile == null) return;
    String imagePath = state.selectedImage!.imageXFile.path;

    ImageGallerySaverPlus.saveFile(imagePath,
        isReturnPathOfIOS: Platform.isIOS);
    return;
  }

  void updateSelectedImage(CapturedImage image) {
    emit(state.copyWith(selectedImage: image));
  }

  void deleteSelectedImage() {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    List<CapturedImage> selectedAlbumList =
        List.from(state.selectedAlbumImageList);
    List<CapturedImage> allToggledImages = List.from(state.photosToggled);
    CapturedImage? selectedImage = state.selectedImage;

    int selectedIndex = photosTaken.indexWhere((test) => test == selectedImage);
    if (selectedIndex == -1) return;

    int newIndex = selectedIndex == 0 ? 1 : selectedIndex - 1;
    CapturedImage? newImage = selectedAlbumList.elementAtOrNull(newIndex);

    if (allToggledImages.contains(selectedImage)) {
      allToggledImages.remove(selectedImage);
    }

    photosTaken.removeWhere((test) => test == selectedImage);
    emit(state.copyWith(
      photosTaken: photosTaken,
      selectedImage: newImage,
      photosToggled: allToggledImages,
    ));
  }

  Future<void> uploadSelectedImage() async {
    CapturedImage? image = state.selectedImage;

    if (image == null) return;

    String? error;
    (_, error) = await dataRepository.addOneImageToAlbum(image);
    if (error == "Image data failed") {
      Map<String, CapturedImage> failedImages = Map.from(state.failedUploads);
      failedImages.putIfAbsent(image.uuid, () => image);

      CustomException exception = CustomException(errorString: error);
      emit(state.copyWith(
          failedUploads: failedImages, loading: false, exception: exception));
      emit(state.copyWith(exception: CustomException.empty));
      return;
    }
    if (error != null) {
      CustomException exception = CustomException(errorString: error);
      emit(state.copyWith(loading: false, exception: exception));
      emit(state.copyWith(exception: CustomException.empty));
      return;
    }
    instance.logEvent(name: "images_uploaded", parameters: {"count": 1});
    deleteSelectedImage();
  }

  Future<void> uploadAllImagesToAlbum() async {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    List<CapturedImage> albumList = List.from(state.selectedAlbumImageList);
    List<CapturedImage> allSelectedImages = List.from(state.photosToggled);
    int imageCount = albumList.length;

    for (CapturedImage image in albumList) {
      //bool success = false;
      String? error;
      (_, error) = await dataRepository.addOneImageToAlbum(image);
      if (error == "Image data failed") {
        Map<String, CapturedImage> failedImages = Map.from(state.failedUploads);
        failedImages.putIfAbsent(image.uuid, () => image);

        CustomException exception = CustomException(errorString: error);
        emit(state.copyWith(
            failedUploads: failedImages, loading: false, exception: exception));
        emit(state.copyWith(exception: CustomException.empty));
        return;
      }
      if (error != null) {
        CustomException exception = CustomException(errorString: error);
        emit(state.copyWith(loading: false, exception: exception));
        emit(state.copyWith(exception: CustomException.empty));
        return;
      }
      photosTaken.remove(image);
      List<CapturedImage> _photosTaken = List.from(photosTaken);
      allSelectedImages.removeWhere((test) => test == image);
      emit(state.copyWith(
        photosToggled: allSelectedImages,
        photosTaken: _photosTaken,
      ));
    }
    instance
        .logEvent(name: "images_uploaded", parameters: {"count": imageCount});
    emit(state.copyWith(
      //photosTaken: photosTaken,
      photosToggled: allSelectedImages,
    ));
  }

  Future<void> uploadToggledPhotos() async {
    List<CapturedImage> photosSelected =
        List.from(state.selectedAlbumToggleImageList);
    List<CapturedImage> photosTaken = List.from(state.photosTaken);

    for (CapturedImage image in state.selectedAlbumToggleImageList) {
      //bool success = false;
      String? error;
      (_, error) = await dataRepository.addOneImageToAlbum(image);
      if (error == "Image data upload failed") {
        Map<String, CapturedImage> failedImages = Map.from(state.failedUploads);
        failedImages.putIfAbsent(image.uuid, () => image);

        CustomException exception = CustomException(errorString: error);
        emit(state.copyWith(
            failedUploads: failedImages, loading: false, exception: exception));
        emit(state.copyWith(exception: CustomException.empty));
        return;
      }
      if (error != null) {
        CustomException exception = CustomException(errorString: error);
        emit(state.copyWith(loading: false, exception: exception));
        emit(state.copyWith(exception: CustomException.empty));
        return;
      }
      photosSelected.removeWhere((test) => test == image);
      photosTaken.removeWhere((test) => test == image);
      instance.logEvent(
          name: "images_uploaded",
          parameters: {"count": state.selectedAlbumImageList.length});
      emit(state.copyWith(photosTaken: photosTaken));
    }
    emit(state.copyWith(photosToggled: photosSelected));
  }

  void changeSelectedAlbum(Album? album) {
    emit(state.copyWith(selectedAlbum: album));
  }

  void changeEditAlbum(Album? album) {
    emit(state.copyWith(selectedAlbum: album));
    if (state.selectedAlbumImageList.isNotEmpty) {
      emit(state.copyWith(
        selectedImage: state.selectedAlbumImageList[0],
        captionTextController: TextEditingController(
            text: state.selectedAlbumImageList[0].caption),
      ));
    } else {
      emit(state.copyWith(
        selectedImage: null,
        captionTextController: TextEditingController(text: null),
      ));
    }
  }

  void addPhotoToList(CapturedImage capturedImage) {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);

    photosTaken.add(capturedImage);
    instance.logEvent(name: "photo_taken");

    emit(state.copyWith(photosTaken: photosTaken));
  }

  void addListOfPhotosToList(List<XFile> imageList) {
    List<CapturedImage> images = List.from(state.photosTaken);

    if (state.selectedAlbum == null && album == null) return;
    Album activeAlbum = album == null ? state.selectedAlbum! : album!;

    UploadType type = activeAlbum.revealDateTime.isBefore(DateTime.now())
        ? UploadType.forgotShot
        : UploadType.snap;

    for (XFile file in imageList) {
      CapturedImage image = CapturedImage(
        imageXFile: file,
        capturedAt: DateTime.now(),
        albumID: activeAlbum.albumId,
        type: type,
      );
      images.add(image);
    }

    instance.logEvent(
        name: "photos_selected", parameters: {"count": images.length});

    emit(state.copyWith(photosTaken: images));
  }

  void updateImageCaptionWithText(CapturedImage capturedImage, String text) {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    int index = photosTaken.indexOf(capturedImage);

    photosTaken[index].caption = text;
    emit(state.copyWith(photosTaken: photosTaken));
  }

  void changeSelectedImageAlbum(Album album, String albumID) {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    CapturedImage? image = state.selectedImage;

    if (image == null) return;
    int index = photosTaken.indexOf(image);

    image.albumID = albumID;
    photosTaken[index] = image;

    emit(state.copyWith(
      photosTaken: photosTaken,
      selectedAlbum: album,
      selectedImage: image,
    ));
  }

  void removeToggledImagesFromUploadList() {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    List<CapturedImage> photosSelected = List.from(state.photosToggled);

    for (CapturedImage image in state.photosToggled) {
      photosTaken.removeWhere((test) => test == image);
      photosSelected.removeWhere((test) => test == image);
      emit(state.copyWith(photosTaken: photosTaken));
    }

    emit(state.copyWith(photosToggled: photosSelected));
  }

  @override
  CameraState? fromJson(Map<String, dynamic> json) {
    List<CapturedImage> photosTaken = [];
    Map<String, CapturedImage> failedUploads = {};

    if (mode == UploadMode.unlockedAlbums) {
      dynamic capturedImages = json['photos_taken'];
      dynamic failedImages = json['failed_images'];

      for (var item in capturedImages) {
        CapturedImage image = CapturedImage.fromJson(item);
        photosTaken.add(image);
      }

      for (var item in failedImages) {
        CapturedImage image = CapturedImage.fromJson(item);
        failedUploads.putIfAbsent(image.uuid, () => image);
      }
    }

    CameraState empty = CameraState.empty();

    return empty.copyWith(
      photosTaken: photosTaken,
      failedUploads: failedUploads,
    );
  }

  @override
  Map<String, dynamic>? toJson(CameraState state) {
    Map<String, dynamic> hydratedCache = {};

    //jsonify photos taken
    List<Map<String, dynamic>> photosTakenJson = [];
    List<Map<String, dynamic>> failedImageUploads = [];
    for (CapturedImage photo in state.photosTaken) {
      photosTakenJson.add(photo.toJson());
    }
    hydratedCache['photos_taken'] = photosTakenJson;

    for (CapturedImage photo in state.failedUploads.values.toList()) {
      failedImageUploads.add(photo.toJson());
    }

    hydratedCache['failed_images'] = failedImageUploads;

    return hydratedCache;
  }

  @override
  Future<void> close() {
    if (albumStreamSubscription != null) {
      albumStreamSubscription?.cancel();
    }

    return super.close();
  }
}
