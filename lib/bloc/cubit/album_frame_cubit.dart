import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/custom_exception.dart';
import 'package:shared_photo/models/guest.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';

part 'album_frame_state.dart';

class AlbumFrameCubit extends Cubit<AlbumFrameState> {
  RealtimeRepository realtimeRepository;
  DataRepository dataRepository;
  String albumID;
  late StreamSubscription imageStreamSubscription;
  late StreamSubscription albumStreamSubscription;
  AlbumFrameCubit({
    required this.albumID,
    required this.dataRepository,
    required this.realtimeRepository,
  }) : super(
          AlbumFrameState(
            album: Album.empty,
          ),
        ) {
    // Fetch Album to Initalize
    initializeAlbum();

    realtimeRepository.openAlbumChannelWebSocket(albumID);
    //checkGuestListChange();

    imageStreamSubscription = dataRepository.imageStream.listen((event) {
      Photo newImage = event.image;
      String imageID = event.imageID;

      if (albumID == event.albumID) {
        updateImageInAlbum(imageID, newImage);
      }
    });

    albumStreamSubscription = dataRepository.albumStream.listen((event) {
      StreamOperation operation = event.$1;
      Album album = event.$2;
      if (album.albumId == albumID) {
        switch (operation) {
          case StreamOperation.add:
          case StreamOperation.update:
            emit(state.copyWith(
                album: album, images: List.from(album.imageMap.values)));
            setRankedImages();
            if (state.images.isNotEmpty && state.selectedImage == null) {
              emit(state.copyWith(selectedImage: state.images[0]));
            }
          case StreamOperation.delete:
        }
      }
    });
  }

  void initializeAlbum() async {
    emit(state.copyWith(loading: true));

    Album updatedAlbum = await dataRepository.getAlbumByID(albumID);

    emit(state.copyWith(
      album: updatedAlbum,
      images: List.from(updatedAlbum.images),
      loading: false,
    ));

    // Set Internal Ranked Images
    setRankedImages();
    if (state.images.isNotEmpty) {
      emit(state.copyWith(selectedImage: state.images[0]));
    }
  }

  void setRankedImages() {
    List<Photo> rankedImages = List.from(state.images);

    // Set Ranked
    rankedImages.sort((a, b) {
      if (a.upvotes == b.upvotes) {
        return a.capturedDatetime.compareTo(b.capturedDatetime);
      } else {
        return b.upvotes.compareTo(a.upvotes);
      }
    });

    // Emit Ranked Images
    emit(state.copyWith(
      rankedImages: rankedImages,
    ));
  }

  void initalizeImageFrameWithSelectedImage(Photo selectedImage) {
    int selectedIndex = state.imageFrameTimelineList.indexOf(selectedImage);
    Photo image = state.imageFrameTimelineList[selectedIndex];
    emit(state.copyWith(
      selectedImage: image,
    ));
  }

  void updateImageFrameWithSelectedImage(int selectedIndex,
      {required bool changeMainPage, required bool changeMiniMap}) {
    Photo image = state.imageFrameTimelineList[selectedIndex];
    emit(state.copyWith(selectedImage: image));
  }

  void updateImageInAlbum(String imageID, Photo image) {
    Map<String, Photo> newImageMap = Map.from(state.album.imageMap);
    newImageMap.update(imageID, (value) => image, ifAbsent: () => image);

    Album updatedAlbum = state.album.copyWith(imageMap: newImageMap);

    emit(state.copyWith(album: updatedAlbum));
    setRankedImages();
  }

  void deleteImageInAlbum() async {
    if (state.selectedImage != null) {
      String? error;

      emit(state.copyWith(loading: true));

      List<Photo> timelineImages = state.imageFrameTimelineList;
      int index = timelineImages.indexOf(state.selectedImage!);

      Photo? newSelected;

      if (index == 0) {
        if (timelineImages.length == 1) {
          newSelected = null;
        } else {
          newSelected = timelineImages.elementAt(index + 1);
        }
      } else if (index == timelineImages.length - 1) {
        newSelected = timelineImages.elementAt(index - 1);
      } else {
        newSelected = timelineImages.elementAt(index + 1);
      }

      (_, error) = await dataRepository.deleteImageFromAlbum(
          state.selectedImage!.imageId, albumID);

      if (error != null) {
        CustomException exception = CustomException(errorString: error);
        emit(state.copyWith(loading: false, exception: exception));
        emit(state.copyWith(exception: CustomException.empty));
        return;
      }

      FirebaseAnalytics.instance.logEvent(
          name: "image_deleted",
          parameters: {"image_id": state.selectedImage?.imageId ?? ''});

      if (newSelected == null) {
        emit(state.copyWith(clearSelectedImage: true, loading: false));
        return;
      }
      emit(state.copyWith(selectedImage: newSelected, loading: false));
    }
  }

  Future<(bool, String?)> sendInviteToFriends(
      String guestID, String guestFirst, String guestLast) async {
    bool success;
    String? error;

    emit(state.copyWith(loading: true));

    (success, error) = await dataRepository.inviteUserToAlbum(
        state.album.albumId, guestID, guestFirst, guestLast);

    if (error != null) {
      CustomException exception = CustomException(errorString: error);
      emit(state.copyWith(loading: false, exception: exception));
      emit(state.copyWith(exception: CustomException.empty));
      return (success, exception.errorString);
    }

    FirebaseAnalytics.instance.logEvent(
      name: "event_updated",
      parameters: {
        "type": "friend_invite",
        "value": guestID,
      },
    );

    emit(state.copyWith(loading: false));
    return (success, error);
  }

  Future<bool> updateAlbumVisibility(
      String visibilityString, AlbumVisibility visibility) async {
    String? error;
    emit(state.copyWith(loading: true));

    (_, error) = await dataRepository.updateAlbumVisibility(
        albumID, visibilityString, visibility);

    if (error != null) {
      CustomException exception = CustomException(errorString: error);
      emit(state.copyWith(loading: false, exception: exception));
      emit(state.copyWith(exception: CustomException.empty));
      return false;
    }

    FirebaseAnalytics.instance.logEvent(
      name: "event_updated",
      parameters: {
        "type": "visiblity",
        "value": visibility.description,
      },
    );

    emit(state.copyWith(loading: false));
    return true;
  }

  @override
  Future<void> close() {
    realtimeRepository.closeAlbumChannelWebSocket();
    imageStreamSubscription.cancel();
    albumStreamSubscription.cancel();
    return super.close();
  }
}
