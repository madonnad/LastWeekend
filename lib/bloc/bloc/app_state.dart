part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

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
  final List<CameraDescription> cameras;
  const AuthenticatedState(User user, {required this.cameras})
      : super(status: AppStatus.authenticated, user: user);
}

class CachedAuthenticatedState extends AppState {
  const CachedAuthenticatedState(User user)
      : super(status: AppStatus.authenticated, user: user);
}

class LoadingState extends AppState {
  const LoadingState()
      : super(
          status: AppStatus.unauthenticated,
          user: User.empty,
        );
}
