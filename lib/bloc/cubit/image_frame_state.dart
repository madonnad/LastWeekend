part of 'image_frame_cubit.dart';

class ImageFrameState extends Equatable {
  final String imageId;
  final String owner;
  final String firstName;
  final String lastName;
  final String imageCaption;
  final DateTime uploadDateTime;
  final int likes;
  final int upvotes;
  final bool userLiked;
  final bool userUpvoted;
  final Map<String, Comment> commentMap;
  final List<Engager> likesUID;
  final List<Engager> upvotesUID;
  final bool loading;
  final bool likeLoading;
  final bool upvoteLoading;
  const ImageFrameState({
    required this.imageId,
    required this.owner,
    required this.firstName,
    required this.lastName,
    required this.imageCaption,
    required this.uploadDateTime,
    required this.likes,
    required this.upvotes,
    required this.userLiked,
    required this.userUpvoted,
    required this.likesUID,
    required this.upvotesUID,
    this.commentMap = const {},
    this.loading = false,
    this.likeLoading = false,
    this.upvoteLoading = false,
  });

  factory ImageFrameState.setImageToState({required Image image}) {
    return ImageFrameState(
      imageId: image.imageId,
      owner: image.owner,
      firstName: image.firstName,
      lastName: image.lastName,
      imageCaption: image.imageCaption,
      uploadDateTime: image.uploadDateTime,
      likes: image.likes,
      upvotes: image.upvotes,
      userLiked: image.userLiked,
      userUpvoted: image.userUpvoted,
      likesUID: image.likesUID,
      upvotesUID: image.upvotesUID,
      commentMap: image.commentMap,
      loading: false,
      likeLoading: false,
      upvoteLoading: false,
    );
  }

  ImageFrameState copyWith({
    String? imageId,
    String? owner,
    String? firstName,
    String? lastName,
    String? imageCaption,
    DateTime? uploadDateTime,
    int? likes,
    int? upvotes,
    bool? userLiked,
    bool? userUpvoted,
    Map<String, Comment>? commentMap,
    List<Engager>? likesUID,
    List<Engager>? upvotesUID,
    bool? loading,
    bool? likeLoading,
    bool? upvoteLoading,
  }) {
    return ImageFrameState(
      imageId: imageId ?? this.imageId,
      owner: owner ?? this.owner,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      imageCaption: imageCaption ?? this.imageCaption,
      uploadDateTime: uploadDateTime ?? this.uploadDateTime,
      likes: likes ?? this.likes,
      upvotes: upvotes ?? this.upvotes,
      userLiked: userLiked ?? this.userLiked,
      userUpvoted: userUpvoted ?? this.userUpvoted,
      commentMap: commentMap ?? this.commentMap,
      likesUID: likesUID ?? this.likesUID,
      upvotesUID: upvotesUID ?? this.upvotesUID,
      loading: loading ?? this.loading,
      likeLoading: likeLoading ?? this.likeLoading,
      upvoteLoading: upvoteLoading ?? this.upvoteLoading,
    );
  }

  List<Comment> get comments {
    return commentMap.values.toList();
  }

  String get imageReq {
    String requestUrl = "$goRepoDomain/image?id=$imageId";

    return requestUrl;
  }

  String get avatarReq {
    String requestUrl = "$goRepoDomain/image?id=$owner";

    return requestUrl;
  }

  String get fullName {
    String fullName = "$firstName $lastName";

    return fullName;
  }

  String get dateString {
    var newFormat = DateFormat.yMMMMd('en_US');
    String updatedDt = newFormat.format(uploadDateTime);
    return updatedDt; // 20-04-03
  }

  String get timeString {
    var newFormat = DateFormat("jm");
    String updatedDt = newFormat.format(uploadDateTime);
    return updatedDt; // 20-04-03
  }

  @override
  List<Object?> get props => [
        imageId,
        owner,
        firstName,
        lastName,
        imageCaption,
        uploadDateTime,
        likes,
        upvotes,
        userLiked,
        userUpvoted,
        commentMap,
        likesUID,
        upvotesUID,
        loading,
        likeLoading,
        upvoteLoading,
      ];
}
