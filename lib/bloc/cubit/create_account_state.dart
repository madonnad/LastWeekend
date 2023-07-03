part of 'create_account_cubit.dart';

final class CreateAccountState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final String? email;
  final String? password;
  final String? confirmPassword;

  const CreateAccountState(
      {required this.isLoading,
      this.errorMessage,
      this.email,
      this.password,
      this.confirmPassword});

  @override
  List<Object?> get props =>
      [isLoading, errorMessage, email, password, confirmPassword];
}
