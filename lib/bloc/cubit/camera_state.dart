part of 'camera_cubit.dart';

class CameraState extends Equatable {
  final List<XFile> photosTaken;
  final int? selectedIndex;
  const CameraState({required this.photosTaken, required this.selectedIndex});

  static const empty = CameraState(photosTaken: [], selectedIndex: null);

  CameraState copyWith({
    List<XFile>? photosTaken,
    int? selectedIndex,
  }) {
    return CameraState(
      photosTaken: photosTaken ?? this.photosTaken,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [photosTaken, selectedIndex];
}
