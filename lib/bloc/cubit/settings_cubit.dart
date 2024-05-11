import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/services/image_service.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  User user;
  SettingsCubit({required this.user})
      : super(const SettingsState(loading: false));

  void addProfileImage(XFile file) {
    emit(state.copyWith(profileImageToUpload: file));
  }

  void clearNewImageFile() {
    emit(state.copyWith(profileImageToUpload: null));
  }

  Future<bool> uploadProfilePicture() async {
    emit(state.copyWith(loading: true));
    if (state.profileImageToUpload != null) {
      bool success = await ImageService.postProfilePicture(
          user.token, state.profileImageToUpload!.path, user.id);
      if (success) {
        emit(state.copyWith(loading: false));
        return success;
      } else {
        // TODO: Implement error state and show dialog
        emit(state.copyWith(loading: false));
        return success;
      }
    }
    emit(state.copyWith(loading: false));
    return false;
  }
}
