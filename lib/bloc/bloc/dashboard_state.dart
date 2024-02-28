part of 'dashboard_bloc.dart';

class DashboardState extends Equatable {
  final Map<String, Album> activeAlbumMap;
  final bool loading;

  const DashboardState({
    required this.activeAlbumMap,
    required this.loading,
  });

  static const empty = DashboardState(activeAlbumMap: {}, loading: false);

  DashboardState copyWith({
    Map<String, Album>? activeAlbumMap,
    bool? loading,
  }) {
    return DashboardState(
      activeAlbumMap: activeAlbumMap ?? this.activeAlbumMap,
      loading: loading ?? this.loading,
    );
  }

  List<Album> get activeAlbums {
    return activeAlbumMap.values.toList();
  }

  @override
  List<Object> get props => [activeAlbumMap, loading];
}
