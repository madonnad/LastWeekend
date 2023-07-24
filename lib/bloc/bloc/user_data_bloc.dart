import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart';
import 'package:shared_photo/repositories/data_repository.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final DataRepository dataRepository;
  final AppBloc appBloc;

  UserDataBloc({required this.appBloc, required this.dataRepository})
      : super(UserDataEmptyState()) {
    on<UserDataRequested>(
      (event, emit) async {
        if (event.uid.isNotEmpty) {
          emit(UserDataLoadingState());
          List<Album> albums = await dataRepository.feedAlbumFetch(index: 3);
          emit(UserDataCollectedState(albumList: albums));
          //print(albums);
        } else {
          emit(UserDataEmptyState());
        }
      },
    );

    appBloc.stream.listen(
      (event) {
        if (event is AuthenticatedState) {
          add(UserDataRequested(uid: event.user.id));
        } else {
          add(RemoveUserData());
        }
      },
    );
  }

  List<Album> sortImagesByVotes(List<Album> albums) {
    List<Image> images;
    List<Album> newAlbums = [];

    for (Album album in albums) {
      images = album.images;

      images.sort((a, b) {
        return b.upvotes.compareTo(a.upvotes);
      });

      album.images = images;
      newAlbums.add(album);
    }

    return newAlbums;
  }
}
