import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/guest.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final Album album;
  AlbumBloc({required this.album}) : super(AlbumState(album: album)) {
    on<AlbumEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
