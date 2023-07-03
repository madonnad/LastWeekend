import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository)
      : super(const LoginState(isLoading: false));

  void emailChanged(email) {
    emit(LoginState(isLoading: false, email: email, password: state.password));
  }

  void passwordChanged(password) {
    emit(LoginState(isLoading: false, email: state.email, password: password));
  }

  Future<void> loginWithCredentials(
      {required String email, required String password}) async {
    emit(const LoginState(isLoading: true));

    try {
      await _authenticationRepository.logInWithEmailAndPassword(
          email: email, password: password);

      emit(const LoginState(isLoading: false));
    } catch (e) {
      emit(LoginState(isLoading: false, errorMessage: e.toString()));
      emit(const LoginState(isLoading: false));
    }
  }
}
