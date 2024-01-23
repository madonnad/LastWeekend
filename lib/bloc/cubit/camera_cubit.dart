import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/repositories/go_repository.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  ProfileBloc profileBloc;
  GoRepository goRepository;
  CameraCubit({required this.profileBloc, required this.goRepository})
      : super(CameraState.empty(profileBloc.state.unlockedAlbums));

  Future<void> uploadImagesToAlbums(String token) async {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);
    List<CapturedImage> failedUploads = [];

    emit(state.copyWith(loading: true));

    for (int i = 0; i < photosTaken.length; i++) {
      CapturedImage image = photosTaken[i];
      try {
        bool uploadSucceeded = await goRepository.postNewImage(token, image);
        if (!uploadSucceeded) {
          throw false;
        }

        photosTaken.removeAt(i);
        emit(state.copyWith(photosTaken: photosTaken));
        i--;
      } catch (e) {
        failedUploads.add(image);
        continue;
      }
    }
    emit(state
        .copyWith(photosTaken: failedUploads, loading: false, uploadList: []));
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
    emit(state.copyWith(
      selectedImage: state.selectedAlbumImageList[0],
      captionTextController:
          TextEditingController(text: state.selectedAlbumImageList[0].caption),
    ));
  }

  void addPhotoToList(CapturedImage capturedImage) {
    List<CapturedImage> photosTaken = List.from(state.photosTaken);

    photosTaken.add(capturedImage);

    emit(state.copyWith(photosTaken: photosTaken));
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

  void removePhotoFromList(BuildContext context, CapturedImage image) {
    List<CapturedImage> photosTaken = state.photosTaken;
    CapturedImage selectedImage = image;
    int index;
    List<CapturedImage> selectedAlbumList;
    int selectedAlbumLength;
    int selectedAlbumMaxIndex;

    if (photosTaken.length == 1) {
      Navigator.of(context).pop();
      emit(state.copyWith(
          photosTaken: [],
          selectedImage: null,
          captionTextController: TextEditingController()));
      return;
    }

    if (state.mapOfAlbumImages[state.selectedAlbum] == null) {
      return;
    } else {
      selectedAlbumList = state.mapOfAlbumImages[state.selectedAlbum]!;
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
}
