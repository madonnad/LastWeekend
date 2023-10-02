import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/user.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';
import 'package:shared_photo/repositories/data_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthenticationRepository _authenticationRepository;
  final Auth0Repository _auth0repository;
  final DataRepository _dataRepository;

  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required DataRepository dataRepository,
    required Auth0Repository auth0repository,
  })  : _authenticationRepository = authenticationRepository,
        _auth0repository = auth0repository,
        _dataRepository = dataRepository,
        super(const LoadingState()) {
    on<AppUserChanged>(
      (event, emit) {
        if (event.user != User.empty) {
          emit(AuthenticatedState(event.user));
        } else {
          emit(const UnauthenticatedState());
        }
      },
    );

    on<AppLogoutRequested>(
      (event, emit) {
        unawaited(_auth0repository.logout());
      },
    );
    _auth0repository.userStream();

    _auth0repository.user.listen((user) => add(AppUserChanged(user)));
  }

  @override
  Future<void> close() {
    //_userSubscription.cancel();
    return super.close();
  }
}

/*authenticationRepository.currentUser.isNotEmpty
? CachedAuthenticatedState(authenticationRepository.currentUser)
: */
