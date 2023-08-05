// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'feed_bloc.dart';

final class FeedState extends Equatable {
  final List<Album> albums;
  final String? error;
  final int loadedToPosition;
  final bool loading;

  const FeedState({
    required this.albums,
    this.error,
    required this.loadedToPosition,
    required this.loading,
  });

  static const empty =
      FeedState(albums: [], loadedToPosition: 0, loading: false);

  FeedState copyWith({
    List<Album>? albums,
    String? error,
    int? loadedToPosition,
    bool? loading,
  }) {
    return FeedState(
        albums: albums ?? this.albums,
        loadedToPosition: loadedToPosition ?? this.loadedToPosition,
        loading: loading ?? this.loading,
        error: error ?? this.error);
  }

  @override
  List<Object> get props => [albums, loadedToPosition, loading];
}

/* class FeedEmptyState extends FeedState {}

class FeedLoadingState extends FeedState {}

class FeedFetchFailed extends FeedState {
  final String error;
  const FeedFetchFailed({
    required this.error,
  });
}

class FeedPopulatedState extends FeedState {
  final List<Album> albums;
  final int loadedToPosition;

  const FeedPopulatedState({
    required this.albums,
    required this.loadedToPosition,
  });
} */
