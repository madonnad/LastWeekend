part of 'feed_slideshow_cubit.dart';

@immutable
class FeedSlideshowState extends Equatable {
  final PageController pageController;
  final int currentPage;
  final Album album;
  final String avatarUrl;
  final String imageOwnerName;

  const FeedSlideshowState({
    required this.pageController,
    required this.album,
    required this.avatarUrl,
    required this.imageOwnerName,
    this.currentPage = 0,
  });

  FeedSlideshowState copyWith({
    PageController? pageController,
    Album? album,
    int? currentPage,
    String? avatarUrl,
    String? imageOwnerName,
  }) {
    return FeedSlideshowState(
      pageController: pageController ?? this.pageController,
      album: album ?? this.album,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentPage: currentPage ?? this.currentPage,
      imageOwnerName: imageOwnerName ?? this.imageOwnerName,
    );
  }

  @override
  List<Object?> get props =>
      [pageController, currentPage, album, avatarUrl, imageOwnerName];
}
