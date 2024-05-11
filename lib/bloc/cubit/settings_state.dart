part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final XFile? profileImageToUpload;
  final bool loading;
  const SettingsState({this.profileImageToUpload, required this.loading});

  SettingsState copyWith({
    XFile? profileImageToUpload,
    bool? loading,
  }) {
    return SettingsState(
      profileImageToUpload: profileImageToUpload ?? this.profileImageToUpload,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [profileImageToUpload, loading];
}
