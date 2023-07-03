import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repositories/authentication_repository.dart';

part 'create_account_state.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  final AuthenticationRepository _authenticationRepository;
  CreateAccountCubit(this._authenticationRepository)
      : super(const CreateAccountState(isLoading: false));

  void emailChanged(email) {
    emit(CreateAccountState(
        isLoading: false, email: email, password: state.password));
  }

  void passwordChanged(password) {
    emit(CreateAccountState(
        isLoading: false, email: state.email, password: password));
  }

  Future<void> loginWithCredentials(
      {required String email, required String password}) async {
    emit(const CreateAccountState(isLoading: true));

    try {
      await _authenticationRepository.logInWithEmailAndPassword(
          email: email, password: password);

      emit(const CreateAccountState(isLoading: false));
    } catch (e) {
      emit(CreateAccountState(isLoading: false, errorMessage: e.toString()));
      emit(const CreateAccountState(isLoading: false));
    }
  }
}
