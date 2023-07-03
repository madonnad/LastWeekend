import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository)
      : super(const LoginState(
          isLoading: false,
          accountCreateMode: false,
        ));

  void setEmailValid(bool status) {
    emit(
      state.copyWith(
        emailMatch: status,
      ),
    );
  }

  void setPasswordValid(bool status) {
    emit(
      state.copyWith(
        passwordMatch: status,
      ),
    );
  }

  void setConfirmPassValid(bool status) {
    emit(
      state.copyWith(
        confirmPassMatch: status,
      ),
    );
  }

  void swapModes() {
    bool mode = state.accountCreateMode;
    emit(state.copyWith(accountCreateMode: !mode));
  }

  Future<void> loginWithCredentials(
      {required String email, required String password}) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _authenticationRepository.logInWithEmailAndPassword(
          email: email, password: password);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      emit(state.copyWith(isLoading: false, errorMessage: ''));
    }
  }

  Future<void> createAccountWithCredentials(
      {required String email, required String password}) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _authenticationRepository.createAccountWithEmailAndPassword(
          email: email, password: password);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      emit(state.copyWith(isLoading: false, errorMessage: ''));
    }
  }
}
