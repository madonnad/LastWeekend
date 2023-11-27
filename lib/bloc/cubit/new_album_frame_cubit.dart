import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'new_album_frame_state.dart';

class NewAlbumFrameCubit extends Cubit<NewAlbumFrameState> {
  NewAlbumFrameCubit() : super(NewAlbumFrameState(filterIndex: 0));

  void changePage(index) {
    emit(state.copyWith(filterIndex: index));
  }
}
