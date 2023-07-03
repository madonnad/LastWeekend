part of 'login_cubit.dart';

final class AuthState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool emailMatch;
  final bool passwordMatch;
  final bool confirmPassMatch;
  final bool accountCreateMode;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPassController;

  const AuthState({
    required this.isLoading,
    required this.accountCreateMode,
    this.emailMatch = false,
    this.passwordMatch = false,
    this.confirmPassMatch = false,
    this.emailController,
    this.passwordController,
    this.confirmPassController,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        isLoading,
        emailMatch,
        passwordMatch,
        errorMessage,
        accountCreateMode,
        confirmPassMatch,
        emailController,
        passwordController,
        confirmPassController
      ];

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? emailMatch,
    bool? passwordMatch,
    bool? confirmPassMatch,
    bool? accountCreateMode,
    TextEditingController? emailController,
    TextEditingController? passwordController,
    TextEditingController? confirmPassController,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      accountCreateMode: accountCreateMode ?? this.accountCreateMode,
      errorMessage: errorMessage ?? this.errorMessage,
      emailMatch: emailMatch ?? this.emailMatch,
      confirmPassMatch: confirmPassMatch ?? this.confirmPassMatch,
      passwordMatch: passwordMatch ?? this.passwordMatch,
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      confirmPassController:
          confirmPassController ?? this.confirmPassController,
    );
  }
}
