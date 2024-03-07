import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/comment.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'image_frame_state.dart';

class ImageFrameCubit extends Cubit<ImageFrameState> {
  DataRepository dataRepository;
  Image image;
  String albumID;
  ImageFrameCubit({
    required this.dataRepository,
    required this.image,
    required this.albumID,
  }) : super(ImageFrameState(image: image)) {
    initializeComments(image);

    dataRepository.imageStream.listen((event) {});
  }

  void changeImageFrameState(Image image) {
    emit(state.copyWith(image: image));
    initializeComments(image);
  }

  Future<void> toggleLike() async {
    Image image = Image.from(state.image);
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
    Image image = Image.from(state.image);
    emit(state.copyWith(upvoteLoading: true));

    late bool userUpvoted;
    late int count;

    (userUpvoted, count) = await dataRepository.toggleImageUpvote(
        albumID, image.imageId, image.userUpvoted);

    image.userUpvoted = userUpvoted;
    image.upvotes = count;

    emit(state.copyWith(upvoteLoading: false, image: image));
  }

  Future<void> initializeComments(Image image) async {
    image.commentMap = {};
    emit(state.copyWith(loading: true, image: image));

    Map<String, Comment> commentMap =
        await dataRepository.initalizeCommentsAndStore(albumID, image.imageId);

    image.commentMap = commentMap;

    emit(state.copyWith(loading: false, image: image));
  }
}
