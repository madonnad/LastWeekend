import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(authenticationRepository.currentUser.isNotEmpty
            ? AuthenticatedState(authenticationRepository.currentUser)
            : const UnauthenticatedState()) {
    on<AppUserChanged>((event, emit) {
      if (event.user != User.empty) {
        emit(AuthenticatedState(event.user));
      } else {
        emit(const UnauthenticatedState());
      }
    });
    on<AppLogoutRequested>(
      (event, emit) {
        unawaited(_authenticationRepository.logout());
      },
    );

    _userSubscription = _authenticationRepository.user
        .listen((user) => add(AppUserChanged(user)));
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
