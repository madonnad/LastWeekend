import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraState.empty);

  void updateSelectedIndex(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void addPhotoToList(XFile file) {
    List<XFile> photosTaken = List.from(state.photosTaken);

    photosTaken.add(file);

    emit(state.copyWith(photosTaken: photosTaken));
  }
}
