part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated, newuser }

sealed class AppState extends Equatable {
  final AppStatus status;
  final User user;

  const AppState({required this.status, required this.user});

  @override
  List<Object> get props => [status, user];
}

class UnauthenticatedState extends AppState {
  const UnauthenticatedState()
      : super(status: AppStatus.unauthenticated, user: User.empty);
}

class AuthenticatedState extends AppState {
  const AuthenticatedState(User user)
      : super(status: AppStatus.authenticated, user: user);
}

class NewUserAuthentictedState extends AppState {
  const NewUserAuthentictedState(User user)
      : super(status: AppStatus.newuser, user: user);
}
