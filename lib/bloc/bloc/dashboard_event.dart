part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class InitializeDash extends DashboardEvent {
  const InitializeDash();
}

class AddAlbumToMap extends DashboardEvent {
  final Album album;

  const AddAlbumToMap({required this.album});
}

class UpdateAlbumInMap extends DashboardEvent {
  final Album album;

  const UpdateAlbumInMap({required this.album});
}
