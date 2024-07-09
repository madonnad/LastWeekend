import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/models/custom_exception.dart';
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
      bool success;
      String? error;
      (success, error) = await ImageService.postProfilePicture(
          user.token, state.profileImageToUpload!.path, user.id);
      if (success) {
        emit(state.copyWith(loading: false));
        return success;
      } else {
        CustomException exception = CustomException(errorString: error);
        emit(state.copyWith(loading: false, exception: exception));
        emit(state.copyWith(loading: false, exception: CustomException.empty));
        return success;
      }
    }
    emit(state.copyWith(loading: false));
    return false;
  }
}
