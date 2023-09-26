import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  //final AuthenticationRepository _authenticationRepository;
  final Auth0Repository _auth0repository;

  AuthCubit(this._auth0repository)
      : super(
          AuthState(
            isLoading: false,
            accountCreateMode: false,
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            confirmPassController: TextEditingController(),
            firstNameController: TextEditingController(),
            lastNameController: TextEditingController(),
          ),
        );

  void setEmailValid(bool status) {
    emit(
      state.copyWith(
        emailValid: status,
      ),
    );
  }

  void setPasswordValid(bool status) {
    emit(
      state.copyWith(
        passwordValid: status,
      ),
    );
  }

  void setConfirmPassValid(bool status) {
    emit(
      state.copyWith(
        confirmPassValid: status,
      ),
    );
  }

  void setFirstNameValid(bool status) {
    emit(
      state.copyWith(
        firstNameValid: status,
      ),
    );
  }

  void setLastNameValid(bool status) {
    emit(
      state.copyWith(
        lastNameValid: status,
      ),
    );
  }

  void swapModes() {
    bool mode = state.accountCreateMode;

    emit(state.copyWith(
        accountCreateMode: !mode,
        confirmPassController: TextEditingController()));
  }

  Future<void> loginWithCredentials(
      {required String email, required String password}) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _auth0repository.loginWithEmailAndPassword(
          email: email, password: password);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      emit(state.copyWith(isLoading: false, errorMessage: ''));
    }
  }

  Future<void> createAccountWithCredentials(
      {required String email,
      required String password,
      required String firstName,
      required String lastName}) async {
    emit(state.copyWith(isLoading: true));

    try {
      await _auth0repository.createAccountWithEmailAndPassword(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName);

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      emit(state.copyWith(isLoading: false, errorMessage: ''));
    }
  }
}
