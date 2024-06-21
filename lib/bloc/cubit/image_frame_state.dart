part of 'image_frame_cubit.dart';

class ImageFrameState extends Equatable {
  final Photo image;
  final TextEditingController commentController;
  final bool loading;
  final bool likeLoading;
  final bool upvoteLoading;
  final bool commentLoading;
  final bool canAddComment;
  final String exception;
  const ImageFrameState({
    required this.image,
    required this.commentController,
    this.loading = false,
    this.likeLoading = false,
    this.upvoteLoading = false,
    this.commentLoading = false,
    this.canAddComment = false,
    this.exception = '',
  });

  ImageFrameState copyWith({
    Photo? image,
    TextEditingController? commentController,
    bool? loading,
    bool? likeLoading,
    bool? upvoteLoading,
    bool? commentLoading,
    bool? canAddComment,
    String? exception,
  }) {
    return ImageFrameState(
      image: image ?? this.image,
      commentController: commentController ?? this.commentController,
      loading: loading ?? this.loading,
      likeLoading: likeLoading ?? this.likeLoading,
      upvoteLoading: upvoteLoading ?? this.upvoteLoading,
      commentLoading: commentLoading ?? this.commentLoading,
      canAddComment: canAddComment ?? this.canAddComment,
      exception: exception ?? this.exception,
    );
  }

  List<Comment> get comments {
    return image.commentMap.values.toList();
  }

  @override
  List<Object?> get props => [
        image,
        commentController,
        loading,
        likeLoading,
        upvoteLoading,
        commentLoading,
        canAddComment,
        exception,
      ];
}
