part of 'login_cubit.dart';

final class LoginState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool emailMatch;
  final bool passwordMatch;
  final bool confirmPassMatch;
  final bool accountCreateMode;

  const LoginState({
    required this.isLoading,
    required this.accountCreateMode,
    this.emailMatch = false,
    this.passwordMatch = false,
    this.confirmPassMatch = false,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        isLoading,
        emailMatch,
        passwordMatch,
        errorMessage,
        accountCreateMode,
        confirmPassMatch
      ];

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? emailMatch,
    bool? passwordMatch,
    bool? confirmPassMatch,
    bool? accountCreateMode,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      accountCreateMode: accountCreateMode ?? this.accountCreateMode,
      errorMessage: errorMessage ?? this.errorMessage,
      emailMatch: emailMatch ?? this.emailMatch,
      confirmPassMatch: confirmPassMatch ?? this.confirmPassMatch,
      passwordMatch: passwordMatch ?? this.passwordMatch,
    );
  }
}
