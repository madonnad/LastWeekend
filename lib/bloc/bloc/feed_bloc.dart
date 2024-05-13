import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/models/image_change.dart';
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

      if (event.albums.isNotEmpty) {
        for (Album album in event.albums) {
          String key = album.albumId;
          if (!feedAlbumMap.containsKey(key) || feedAlbumMap[key] != album) {
            feedAlbumMap[key] = album;
          }
        }
        emit(state.copyWith(
            feedAlbumMap: feedAlbumMap, cursorID: event.albums.last.albumId));
      }
    });

    on<UpdateAlbumImageInFeed>(
      (event, emit) {
        Map<String, Album> feedAlbumMap = Map.from(state.feedAlbumMap);

        String albumID = event.imageChange.albumID;
        String imageID = event.imageChange.imageID;
        Photo image = event.imageChange.image;

        feedAlbumMap[albumID]?.imageMap.update(imageID, (value) => image);

        emit(state.copyWith(feedAlbumMap: feedAlbumMap));
      },
    );

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

    dataRepository.imageStream.listen((event) {
      add(UpdateAlbumImageInFeed(imageChange: event));
    });
  }
}
