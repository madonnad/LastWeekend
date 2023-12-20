part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final List<XFile> photosTaken;
  const CameraState({required this.photosTaken});

  static const empty = CameraState(photosTaken: []);

  CameraState copyWith({List<XFile>? photosTaken}) {
    return CameraState(
      photosTaken: photosTaken ?? this.photosTaken,
    );
  }

  @override
  List<Object?> get props => [photosTaken];
}
