import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final DataRepository dataRepository;

  FeedBloc({
    required this.dataRepository,
  }) : super(FeedState.empty) {
    on<AddAlbumsToFeed>((event, emit) {
      Map<String, Album> feedAlbumMap = Map.from(state.feedAlbumMap);

      for (Album album in event.albums) {
        String key = album.albumId;
        if (!feedAlbumMap.containsKey(key) || feedAlbumMap[key] != album) {
          feedAlbumMap[key] = album;
        }
      }
      emit(state.copyWith(
          feedAlbumMap: feedAlbumMap, cursorID: event.albums.last.albumId));
    });

    dataRepository.feedStream.listen(
      (event) {
        StreamOperation type = event.$1;
        List<Album> albums = event.$2;

        switch (type) {
          case StreamOperation.add:
            add(AddAlbumsToFeed(albums: albums));
          case StreamOperation.delete:
          case StreamOperation.update:
          default:
        }
      },
    );
  }
}
