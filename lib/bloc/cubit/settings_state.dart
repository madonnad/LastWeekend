part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final XFile? profileImageToUpload;
  final bool loading;
  final CustomException exception;
  const SettingsState({
    this.profileImageToUpload,
    required this.loading,
    this.exception = CustomException.empty,
  });

  SettingsState copyWith({
    XFile? profileImageToUpload,
    bool? loading,
    CustomException? exception,
  }) {
    return SettingsState(
      profileImageToUpload: profileImageToUpload ?? this.profileImageToUpload,
      loading: loading ?? this.loading,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object?> get props => [profileImageToUpload, loading, exception];
}
