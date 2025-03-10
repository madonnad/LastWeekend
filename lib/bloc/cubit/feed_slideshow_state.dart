part of 'feed_slideshow_cubit.dart';

@immutable
class FeedSlideshowState extends Equatable {
  final int currentPage;
  final Album album;
  final List<Photo> topThreeImages;
  final String avatarUrl;
  final String imageOwnerName;

  const FeedSlideshowState({
    required this.album,
    this.topThreeImages = const [],
    required this.avatarUrl,
    required this.imageOwnerName,
    this.currentPage = 0,
  });

  FeedSlideshowState copyWith({
    PageController? pageController,
    Album? album,
    List<Photo>? topThreeImages,
    int? currentPage,
    String? avatarUrl,
    String? imageOwnerName,
  }) {
    return FeedSlideshowState(
      album: album ?? this.album,
      topThreeImages: topThreeImages ?? this.topThreeImages,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentPage: currentPage ?? this.currentPage,
      imageOwnerName: imageOwnerName ?? this.imageOwnerName,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        album,
        topThreeImages,
        avatarUrl,
        imageOwnerName,
      ];
}
