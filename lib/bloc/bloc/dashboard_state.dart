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

  List<Album> get sortActiveAlbumList {
    List<Album> activeAlbums = activeAlbumMap.values.toList();
    activeAlbums.sort((a, b) {
      if (a.phase.index != b.phase.index) {
        return a.phase.index.compareTo(b.phase.index);
      } else {
        return b.creationDateTime.compareTo(a.creationDateTime);
      }
    });
    return activeAlbums;
  }

  @override
  List<Object> get props => [activeAlbumMap, loading];
}
