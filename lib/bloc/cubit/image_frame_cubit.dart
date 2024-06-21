import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:http/http.dart' as http;

part 'image_frame_state.dart';

class ImageFrameCubit extends Cubit<ImageFrameState> {
  DataRepository dataRepository;
  User user;
  Photo image;
  String albumID;
  ImageFrameCubit({
    required this.dataRepository,
    required this.user,
    required this.image,
    required this.albumID,
  }) : super(ImageFrameState(
          image: image,
          commentController: TextEditingController(),
        )) {
    changeImageFrameState(image);
    //initializeComments(image);

    dataRepository.imageStream.listen((event) {});
  }

  void changeImageFrameState(Photo image) {
    emit(state.copyWith(image: image));
    initializeComments(image);
  }

  Future<void> toggleLike() async {
    Photo image = Photo.from(state.image);
    emit(state.copyWith(likeLoading: true));

    late bool userLiked;
    late int count;

    (userLiked, count) = await dataRepository.toggleImageLike(
        albumID, image.imageId, image.userLiked);

    image.userLiked = userLiked;
    image.likes = count;

    emit(state.copyWith(likeLoading: false, image: image));
  }

  Future<void> toggleUpvote() async {
    Photo image = Photo.from(state.image);
    emit(state.copyWith(upvoteLoading: true));

    late bool userUpvoted;
    late int count;

    (userUpvoted, count) = await dataRepository.toggleImageUpvote(
        albumID, image.imageId, image.userUpvoted);

    image.userUpvoted = userUpvoted;
    image.upvotes = count;

    emit(state.copyWith(upvoteLoading: false, image: image));
  }

  Future<void> initializeComments(Photo image) async {
    Photo internalImage = Photo.from(image);
    emit(state.copyWith(loading: true, image: image));
    internalImage.commentMap =
        await dataRepository.initalizeCommentsAndStore(albumID, image.imageId);

    emit(state.copyWith(loading: false, image: internalImage));
  }

  void commentTextChange() {
    bool textIsNotEmpty = state.commentController.text != '';

    emit(state.copyWith(canAddComment: textIsNotEmpty));
  }

  Future<void> postComment() async {
    String commentText = state.commentController.text;

    if (commentText == '') return;

    emit(state.copyWith(commentLoading: true));

    Comment? comment = await dataRepository.addCommentToImage(
        albumID, state.image.imageId, commentText);

    if (comment == null) {
      emit(state.copyWith(
          commentLoading: false,
          exception: "Error adding comment to image - try again"));
      emit(state.copyWith(exception: ''));
      return;
    }

    Photo image = Photo.from(state.image);
    image.commentMap[comment.id] = comment;

    emit(state.copyWith(
      commentLoading: false,
      image: image,
      commentController: TextEditingController(),
    ));
  }

  Future<void> downloadImageToDevice() async {
    emit(state.copyWith(loading: true));
    Uri url = Uri.parse(state.image.imageReq);
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${user.token}'
    };

    try {
      final response = await http.get(url, headers: headers);

      img.Image? decodedImage = img.decodeJpg(response.bodyBytes);
      if (decodedImage == null) throw Exception();
      img.Image orientedImage = img.bakeOrientation(decodedImage);

      ImageGallerySaver.saveImage(img.encodeJpg(orientedImage),
          isReturnImagePathOfIOS: Platform.isIOS);
    } catch (e) {
      emit(state.copyWith(loading: false));
      return;
    }
    emit(state.copyWith(loading: false));
    return;
  }
}
