import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:shared_photo/models/custom_exception.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
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
    } catch (e) {
      CustomException exception = CustomException(errorString: e.toString());
      emit(state.copyWith(exception: exception, isLoading: false));
      emit(state.copyWith(isLoading: false, exception: CustomException.empty));
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
      CustomException exception = CustomException(errorString: e.toString());
      emit(state.copyWith(exception: exception, isLoading: false));
      emit(state.copyWith(
        isLoading: false,
        exception: CustomException.empty,
      ));
    }
  }
}
