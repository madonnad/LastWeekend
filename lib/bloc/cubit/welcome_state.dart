part of 'welcome_cubit.dart';

class WelcomeState extends Equatable {
  final XFile? profileImageToUpload;
  final bool loading;
  final CustomException exception;
  const WelcomeState({
    this.profileImageToUpload,
    required this.loading,
    this.exception = CustomException.empty,
  });

  WelcomeState copyWith({
    XFile? profileImageToUpload,
    bool? loading,
    CustomException? exception,
  }) {
    return WelcomeState(
      profileImageToUpload: profileImageToUpload ?? this.profileImageToUpload,
      loading: loading ?? this.loading,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [profileImageToUpload, loading, exception];
}
