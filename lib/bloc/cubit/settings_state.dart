part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final User user;
  final XFile? profileImageToUpload;
  final String? firstName;
  final String? lastName;
  final bool nameMatches;
  final bool loading;
  final CustomException exception;
  const SettingsState({
    required this.user,
    required this.loading,
    this.firstName,
    this.lastName,
    this.nameMatches = true,
    this.profileImageToUpload,
    this.exception = CustomException.empty,
  });

  SettingsState copyWith({
    User? user,
    XFile? profileImageToUpload,
    String? firstName,
    String? lastName,
    bool? nameMatches,
    bool? loading,
    CustomException? exception,
  }) {
    return SettingsState(
      user: user ?? this.user,
      profileImageToUpload: profileImageToUpload ?? this.profileImageToUpload,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nameMatches: nameMatches ?? this.nameMatches,
      loading: loading ?? this.loading,
      exception: exception ?? this.exception,
    );
  }

  SettingsState clearProfileImage() {
    return SettingsState(
      user: user,
      profileImageToUpload: null,
      firstName: firstName,
      lastName: lastName,
      nameMatches: nameMatches,
      loading: loading,
      exception: exception,
    );
  }

  @override
  List<Object?> get props => [
        user,
        firstName,
        lastName,
        nameMatches,
        profileImageToUpload,
        loading,
        exception
      ];
}
