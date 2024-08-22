import 'dart:async';
import 'dart:collection';
import 'dart:io' show Platform;

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/custom_exception.dart';
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

  CameraCubit(
      {required this.dataRepository,
      required this.user,
      required this.mode,
      this.album})
      : super(CameraState.empty()) {
    if (mode == UploadMode.unlockedAlbums) {
      hydrate();
      checkFailedUploads();
      albumStreamSubscription = dataRepository.albumStream.listen((event) {
        StreamOperation streamOperation = event.$1;
        Album album = event.$2;

        // Check if user is in the album that was passed
        bool userIsGuest = album.guests.any((guest) => guest.uid == user.id);

        // Only allow album through if it passes these qualities
        if (userIsGuest && album.phase == AlbumPhases.unlock) {
          switch (streamOperation) {
            case StreamOperation.add:
              addUnlockedAlbums(album);
            case StreamOperation.update:
            case StreamOperation.delete:
          }
        }
      });
      // Initialize Unlocked Album Map
      _initializeUnlockedAlbums();
    } else if (mode == UploadMode.singleAlbum) {
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

  void toggleImageInUploadList(CapturedImage image) {
    List<CapturedImage> imageList = List.from(state.photosSelected);
    if (imageList.contains(image)) {
      imageList.removeWhere((listImage) => listImage == image);
    } else {
      imageList.add(image);
    }
    emit(state.copyWith(photosSelected: imageList));
  }

  void _initializeUnlockedAlbums() {
    Map<String, Album> unlockedMap = Map.from(dataRepository.unlockedAlbums());
    Album? selectedAlbum;
    if (unlockedMap.isNotEmpty) {
      selectedAlbum = unlockedMap.values.toList()[0];
    }

    emit(state.copyWith(albumMap: unlockedMap, selectedAlbum: selectedAlbum));
  }

  Future<void> downloadImageToDevice() async {
    if (state.selectedImage?.imageXFile == null) return;
    String imagePath = state.selectedImage!.imageXFile.path;

    ImageGallerySaver.saveFile(imagePath, isReturnPathOfIOS: Platform.isIOS);
    return;
  }

  Future<void> uploadImagesToAlbums(String token) async {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);

    emit(state.copyWith(loading: true));

    List<CapturedImage> failedUploads =
        await dataRepository.addImagesToAlbum(photosTaken);

    emit(state.copyWith(photosTaken: failedUploads, loading: false));
  }

  void updateSelectedImage(CapturedImage image) {
    emit(state.copyWith(
      selectedImage: image,
      captionTextController: TextEditingController(text: image.caption),
    ));
  }

  Future<void> uploadAllImagesToAlbum() async {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    List<CapturedImage> albumList = List.from(state.selectedAlbumImageList);
    List<CapturedImage> allSelectedImages = List.from(state.photosSelected);

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
      photosTaken.removeWhere((test) => test == image);
      allSelectedImages.removeWhere((test) => test == image);
      emit(state.copyWith(
        photosSelected: allSelectedImages,
      ));
    }
    emit(state.copyWith(
      photosTaken: photosTaken,
      photosSelected: allSelectedImages,
    ));
  }

  Future<void> uploadSelectedPhotos() async {
    List<CapturedImage> photosSelected =
        List.from(state.selectedAlbumSelectedImageList);
    List<CapturedImage> photosTaken = List.from(state.photosTaken);

    for (CapturedImage image in state.selectedAlbumSelectedImageList) {
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
      photosSelected.removeWhere((test) => test == image);
      photosTaken.removeWhere((test) => test == image);
      emit(state.copyWith(photosTaken: photosTaken));
    }
    emit(state.copyWith(photosSelected: photosSelected));
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

    emit(state.copyWith(photosTaken: photosTaken));
  }

  void addListOfPhotosToList(List<XFile> imageList, UploadType type) {
    List<CapturedImage> images = List.from(state.photosTaken);

    if (state.selectedAlbum == null && album == null) return;
    Album newAlbum = album == null ? state.selectedAlbum! : album!;

    for (XFile file in imageList) {
      CapturedImage image = CapturedImage(
        imageXFile: file,
        albumID: newAlbum.albumId,
        type: type,
      );
      images.add(image);
    }

    emit(state.copyWith(photosTaken: images));
  }

  void updateImageCaption(CapturedImage capturedImage) {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    int index = photosTaken.indexOf(capturedImage);

    photosTaken[index].caption = state.captionTextController.text;
    emit(state.copyWith(photosTaken: photosTaken));
  }

  void updateImageCaptionWithText(CapturedImage capturedImage, String text) {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    int index = photosTaken.indexOf(capturedImage);

    photosTaken[index].caption = text;
    emit(state.copyWith(photosTaken: photosTaken));
  }

  void toggleMonthlyRecap(CapturedImage selectedImage) {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    int index = photosTaken.indexOf(selectedImage);
    photosTaken[index] =
        photosTaken[index].setAddToRecap(!photosTaken[index].addToRecap);
    !selectedImage.addToRecap;

    emit(state.copyWith(
        photosTaken: photosTaken, selectedImage: photosTaken[index]));
  }

  void changeImageAlbum(Album album, String albumID) {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    if (state.selectedImage == null) return;
    int index = photosTaken.indexOf(state.selectedImage!);

    photosTaken[index].albumID = albumID;

    emit(state.copyWith(photosTaken: photosTaken, selectedAlbum: album));
  }

  void removePhotoFromList(BuildContext context, CapturedImage image) {
    List<CapturedImage> photosTaken = state.photosTaken;
    CapturedImage selectedImage = image;
    int index;
    List<CapturedImage> selectedAlbumList;
    int selectedAlbumLength;
    int selectedAlbumMaxIndex;

    if (photosTaken.length == 1) {
      // Navigator.of(context).pop();
      emit(state.copyWith(
          photosTaken: [],
          selectedImage: null,
          captionTextController: TextEditingController()));
      return;
    }

    if (state.mapOfAlbumImages[state.selectedAlbum!.albumId] == null) {
      return;
    } else {
      selectedAlbumList = state.mapOfAlbumImages[state.selectedAlbum!.albumId]!;
      selectedAlbumLength = selectedAlbumList.length;
      selectedAlbumMaxIndex = selectedAlbumLength - 1;
      index = selectedAlbumList.indexWhere((element) => element == image);
    }

    if (selectedAlbumLength == 1) {
      List<Album> albumsWithImages =
          List.from(state.mapOfAlbumImages.keys.toList());
      albumsWithImages.remove(state.selectedAlbum);

      Album selectedAlbum = albumsWithImages[0];
      selectedImage = state.mapOfAlbumImages[selectedAlbum]![0];

      emit(state.copyWith(
        selectedAlbum: selectedAlbum,
        selectedImage: selectedImage,
        captionTextController:
            TextEditingController(text: selectedImage.caption),
      ));

      photosTaken.remove(image);
      return;
    }

    if (index == selectedAlbumMaxIndex) {
      selectedAlbumList.remove(image);
      photosTaken.remove(image);
      selectedImage = selectedAlbumList[selectedAlbumMaxIndex - 1];
    } else {
      selectedAlbumList.remove(image);
      photosTaken.remove(image);
      selectedImage = selectedAlbumList[index];
    }

    emit(
      state.copyWith(
          photosTaken: photosTaken,
          selectedImage: selectedImage,
          captionTextController:
              TextEditingController(text: selectedImage.caption)),
    );
  }

  void removeImageFromUploadList() {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    List<CapturedImage> photosSelected = List.from(state.photosSelected);

    for (CapturedImage image in state.photosSelected) {
      photosTaken.removeWhere((test) => test == image);
      photosSelected.removeWhere((test) => test == image);
      emit(state.copyWith(photosTaken: photosTaken));
    }

    emit(state.copyWith(photosSelected: photosSelected));
  }

  @override
  CameraState? fromJson(Map<String, dynamic> json) {
    List<CapturedImage> photosTaken = [];
    Map<String, CapturedImage> failedUploads = {};

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
    albumStreamSubscription?.cancel();

    return super.close();
  }
}
