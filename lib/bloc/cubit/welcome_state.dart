part of 'welcome_cubit.dart';

class WelcomeState extends Equatable {
  final XFile? profileImageToUpload;
  final bool loading;
  const WelcomeState({this.profileImageToUpload, required this.loading});

  WelcomeState copyWith({
    XFile? profileImageToUpload,
    bool? loading,
  }) {
    return WelcomeState(
      profileImageToUpload: profileImageToUpload ?? this.profileImageToUpload,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [profileImageToUpload, loading];
}
