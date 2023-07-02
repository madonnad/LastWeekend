part of 'login_cubit.dart';

final class LoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String? email;
  final String? password;

  const LoginState({
    required this.isLoading,
    this.email,
    this.password,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, email, password, errorMessage];
}
