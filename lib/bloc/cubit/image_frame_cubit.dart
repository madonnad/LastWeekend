import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/image.dart' as img;
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'image_frame_state.dart';

class ImageFrameCubit extends Cubit<ImageFrameState> {
  DataRepository dataRepository;
  img.Image image;
  String albumID;
  ImageFrameCubit({
    required this.dataRepository,
    required this.image,
    required this.albumID,
  }) : super(ImageFrameState(
          image: image,
          commentController: TextEditingController(),
        )) {
    initializeComments(image);

    dataRepository.imageStream.listen((event) {});
  }

  void changeImageFrameState(img.Image image) {
    emit(state.copyWith(image: image));
    initializeComments(image);
  }

  Future<void> toggleLike() async {
    img.Image image = img.Image.from(state.image);
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
    img.Image image = img.Image.from(state.image);
    emit(state.copyWith(upvoteLoading: true));

    late bool userUpvoted;
    late int count;

    (userUpvoted, count) = await dataRepository.toggleImageUpvote(
        albumID, image.imageId, image.userUpvoted);

    image.userUpvoted = userUpvoted;
    image.upvotes = count;

    emit(state.copyWith(upvoteLoading: false, image: image));
  }

  Future<void> initializeComments(img.Image image) async {
    image.commentMap = {};
    emit(state.copyWith(loading: true, image: image));

    Map<String, Comment> commentMap =
        await dataRepository.initalizeCommentsAndStore(albumID, image.imageId);

    image.commentMap = commentMap;

    emit(state.copyWith(loading: false, image: image));
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

    img.Image image = img.Image.from(state.image);
    image.commentMap[comment.id] = comment;

    emit(state.copyWith(
      commentLoading: false,
      image: image,
      commentController: TextEditingController(),
    ));
  }
}
