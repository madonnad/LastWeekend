part of 'create_account_cubit.dart';

final class CreateAccountState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const CreateAccountState({
    required this.isLoading,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage];
}
