import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/models/custom_exception.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/services/image_service.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  UserRepository userRepository;
  SettingsCubit({required this.userRepository})
      : super(SettingsState(loading: false, user: userRepository.user));

  void updateFirstName(String value) {
    emit(state.copyWith(firstName: value));
    checkNamesMatch();
  }

  void updateLastName(String value) {
    emit(state.copyWith(lastName: value));
    checkNamesMatch();
  }

  void addProfileImage(XFile file) {
    emit(state.copyWith(profileImageToUpload: file));
  }

  void clearNewImageFile() {
    emit(state.copyWith(profileImageToUpload: null));
  }

  void checkNamesMatch() {
    if ((state.firstName == "" || state.firstName == null) &&
        (state.lastName == "" || state.lastName == null)) {
      emit(state.copyWith(nameMatches: true));
      return;
    }
    if (state.firstName != state.user.firstName ||
        state.lastName != state.user.lastName) {
      emit(state.copyWith(nameMatches: false));
    }
  }

  void updateFirstLastName() async {
    String? first = state.user.firstName;
    String? last = state.user.lastName;
    String? error;

    if (state.firstName != null && state.firstName != "") {
      first = state.firstName!;
    }
    if (state.lastName != null && state.lastName != "") {
      last = state.lastName!;
    }

    emit(state.copyWith(loading: true));
    (first, last, error) =
        await userRepository.updateUsersFirstLast(first, last);
    if (error != null) {
      CustomException exception = CustomException(errorString: error);
      emit(state.copyWith(loading: false, exception: exception));
      emit(state.copyWith(exception: CustomException.empty));
      return;
    }
    User newUser = state.user.copyWith(firstName: first, lastName: last);
    emit(state.copyWith(
        user: newUser, loading: false, firstName: "", lastName: ""));
  }

  Future<bool> uploadProfilePicture() async {
    emit(state.copyWith(loading: true));
    if (state.profileImageToUpload != null) {
      bool success;
      String? error;
      (success, error) = await ImageService.postProfilePicture(
          state.user.token, state.profileImageToUpload!.path, state.user.id);
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
