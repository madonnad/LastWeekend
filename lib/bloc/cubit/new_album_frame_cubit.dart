import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_photo/models/album.dart';

part 'new_album_frame_state.dart';

class NewAlbumFrameCubit extends Cubit<NewAlbumFrameState> {
  Album album;
  NewAlbumFrameCubit({required this.album})
      : super(NewAlbumFrameState(filterIndex: 0, album: album));

  void changePage(index) {
    emit(state.copyWith(filterIndex: index));
  }
}
