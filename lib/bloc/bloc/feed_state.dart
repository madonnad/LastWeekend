// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'feed_bloc.dart';

class FeedState extends Equatable {
  final Map<String, Album> feedAlbumMap;
  final String? error;
  final String cursorID;
  final bool loading;

  const FeedState({
    required this.feedAlbumMap,
    this.error,
    required this.cursorID,
    required this.loading,
  });

  static const empty =
      FeedState(feedAlbumMap: {}, cursorID: '', loading: false);

  FeedState copyWith({
    Map<String, Album>? feedAlbumMap,
    String? error,
    String? cursorID,
    bool? loading,
  }) {
    return FeedState(
        feedAlbumMap: feedAlbumMap ?? this.feedAlbumMap,
        cursorID: cursorID ?? this.cursorID,
        loading: loading ?? this.loading,
        error: error ?? this.error);
  }

  List<Album> get feedAlbumList {
    return feedAlbumMap.values.toList();
  }

  List<Album> get revealedFeedAlbumList {
    return feedAlbumMap.values
        .where((element) =>
            element.phase == AlbumPhases.reveal && element.images.isNotEmpty)
        .toList()
      ..sort(((a, b) => b.revealDateTime.compareTo(a.revealDateTime)));
  }

  @override
  List<Object> get props => [feedAlbumMap, cursorID, loading];
}
