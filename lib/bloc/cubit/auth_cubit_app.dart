import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part './auth_state_app.dart';

class AuthCubitApp extends Cubit<AuthStateApp> {
  final supabase = Supabase.instance.client;
  late StreamSubscription authStream;

  AuthCubitApp() : super(LogInScreenState()) {
    authStream = supabase.auth.onAuthStateChange.listen(
      (response) async {
        final AuthChangeEvent event = response.event;
        if (event == AuthChangeEvent.signedIn) {
          final Session session = response.session!;
          emit(LoggedInState(uid: session.user.id));
        } else if (event == AuthChangeEvent.signedOut) {
          emit(LogInScreenState());
        }
      },
    );
  }

  goToCreateAccount() {
    emit(CreateAccountState());
  }

  goToLoginScreen() {
    emit(LogInScreenState());
  }

  Future<void> registerNewEmailUser(email, password) async {
    try {
      AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      emit(AddInfoState(uid: res.user!.id));
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> addPersonalInfoToDB(personalPayload) async {
    String uid = state.uid!;
    String firstName = personalPayload['firstName'];
    String lastName = personalPayload['lastName'];
    await supabase.from('users').insert({
      'user_id': uid,
      'first_name': firstName,
      'last_name': lastName,
    });
  }

  Future<void> loginUser(email, password) async {
    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> logOutUser() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      debugPrint('Error $e');
    }
  }
}

/* authStream = supabase.auth.onAuthStateChange.listen(
      (response) async {
        final AuthChangeEvent event = response.event;
        if (event == AuthChangeEvent.signedIn) {
          final Session session = response.session!;
          emit(LoggedInState(uid: session.user.id));
        } else if (event == AuthChangeEvent.signedOut) {
          emit(LogInScreenState());
        }
      },
    ); */