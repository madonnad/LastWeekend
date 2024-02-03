import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/repositories/data_repository.dart';
import 'package:shared_photo/repositories/go_repository.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final AppBloc appBloc;
  final GoRepository goRepository;
  final DataRepository dataRepository;

  FeedBloc({
    required this.appBloc,
    required this.goRepository,
    required this.dataRepository,
  }) : super(FeedState.empty) {
    on<FeedDataRequested>((event, emit) async {
      emit(state.copyWith(loading: true));
      try {
        List<Album> albums = state.albums;
        List<Album> fetchedAlbums;

        fetchedAlbums =
            await dataRepository.getFeedAlbums(appBloc.state.user.token);

        /*fetchedAlbums = await dataRepository.feedAlbumFetch(
            from: event.index, to: event.index + 50);*/
        albums += fetchedAlbums;

        emit(state.copyWith(albums: albums, loading: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
        emit(state.copyWith(error: '', loading: false));
      }
    });

    if (appBloc.state is AuthenticatedState) {
      add(const FeedDataRequested(index: 0));
    }
  }
}
