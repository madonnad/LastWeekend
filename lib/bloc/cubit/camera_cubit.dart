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
        await dataRepository.addImageToAlbum(photosTaken);

    emit(state.copyWith(photosTaken: failedUploads, loading: false));
  }

  void updateSelectedImage(CapturedImage image) {
    emit(state.copyWith(
      selectedImage: image,
      captionTextController: TextEditingController(text: image.caption),
    ));
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
          imageXFile: file, albumID: newAlbum.albumId, type: type);
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

  @override
  CameraState? fromJson(Map<String, dynamic> json) {
    List<CapturedImage> photosTaken = [];

    dynamic capturedImages = json['photos_taken'];

    for (var item in capturedImages) {
      CapturedImage image = CapturedImage.fromJson(item);
      photosTaken.add(image);
    }

    CameraState empty = CameraState.empty();

    return empty.copyWith(photosTaken: photosTaken);
  }

  @override
  Map<String, dynamic>? toJson(CameraState state) {
    Map<String, dynamic> hydratedCache = {};

    //jsonify photos taken
    List<Map<String, dynamic>> photosTakenJson = [];
    for (CapturedImage photo in state.photosTaken) {
      photosTakenJson.add(photo.toJson());
    }
    hydratedCache['photos_taken'] = photosTakenJson;

    return hydratedCache;
  }

  @override
  Future<void> close() {
    albumStreamSubscription?.cancel();

    return super.close();
  }
}
