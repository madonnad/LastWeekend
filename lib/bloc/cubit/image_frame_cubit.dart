import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/engager.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/utils/api_variables.dart';

part 'image_frame_state.dart';

class ImageFrameCubit extends Cubit<ImageFrameState> {
  DataRepository dataRepository;
  Image image;
  String albumID;
  ImageFrameCubit({
    required this.dataRepository,
    required this.image,
    required this.albumID,
  }) : super(ImageFrameState.setImageToState(
          image: image,
        )) {
    initializeComments(image);

    dataRepository.imageStream.listen((event) {});
  }

  void changeImageFrameState(Image image) {
    emit(ImageFrameState.setImageToState(image: image));
    initializeComments(image);
  }

  Future<void> toggleLike() async {
    emit(state.copyWith(likeLoading: true));

    late bool userLiked;
    late int count;

    (userLiked, count) = await dataRepository.toggleImageLike(
        albumID, image.imageId, image.userLiked);

    emit(
        state.copyWith(likeLoading: false, userLiked: userLiked, likes: count));
  }

  Future<void> toggleUpvote() async {
    emit(state.copyWith(upvoteLoading: true));

    late bool userUpvoted;
    late int count;

    (userUpvoted, count) = await dataRepository.toggleImageUpvote(
        albumID, image.imageId, image.userUpvoted);

    emit(state.copyWith(
        upvoteLoading: false, userUpvoted: userUpvoted, upvotes: count));
  }

  Future<void> initializeComments(Image image) async {
    emit(state.copyWith(loading: true, commentMap: {}));

    Map<String, Comment> commentMap =
        await dataRepository.initalizeCommentsAndStore(albumID, image.imageId);

    emit(state.copyWith(loading: false, commentMap: commentMap));
  }
}
