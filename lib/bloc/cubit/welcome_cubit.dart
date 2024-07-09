import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/models/custom_exception.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/services/image_service.dart';

part 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  User user;
  WelcomeCubit({required this.user})
      : super(const WelcomeState(loading: false));

  void addProfileImage(XFile file) {
    emit(state.copyWith(profileImageToUpload: file));
  }

  Future<bool> uploadProfilePicture(String userID) async {
    emit(state.copyWith(loading: true));
    if (state.profileImageToUpload != null) {
      bool success;
      String? error;
      (success, error) = await ImageService.postProfilePicture(
          user.token, state.profileImageToUpload!.path, userID);
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
