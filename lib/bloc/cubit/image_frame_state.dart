part of 'image_frame_cubit.dart';

class ImageFrameState extends Equatable {
  final Image image;
  final bool loading;
  final bool likeLoading;
  final bool upvoteLoading;
  const ImageFrameState({
    required this.image,
    this.loading = false,
    this.likeLoading = false,
    this.upvoteLoading = false,
  });

  ImageFrameState copyWith({
    Image? image,
    bool? loading,
    bool? likeLoading,
    bool? upvoteLoading,
  }) {
    return ImageFrameState(
      image: image ?? this.image,
      loading: loading ?? this.loading,
      likeLoading: likeLoading ?? this.likeLoading,
      upvoteLoading: upvoteLoading ?? this.upvoteLoading,
    );
  }

  List<Comment> get comments {
    return image.commentMap.values.toList();
  }

  @override
  List<Object?> get props => [
        image,
        loading,
        likeLoading,
        upvoteLoading,
      ];
}
