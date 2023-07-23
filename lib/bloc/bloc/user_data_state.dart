part of 'user_data_bloc.dart';

abstract class UserDataState extends Equatable {
  final List<Album> albumList;

  const UserDataState({required this.albumList});

  @override
  List<Object> get props => [albumList];
}

class UserDataCollectedState extends UserDataState {
  const UserDataCollectedState({
    required List<Album> albumList,
  }) : super(albumList: albumList);
}

class UserDataEmptyState extends UserDataState {
  UserDataEmptyState() : super(albumList: []);
}

class UserDataLoadingState extends UserDataState {
  UserDataLoadingState() : super(albumList: []);
}

class UserDataErrorState extends UserDataState {
  final String error;
  UserDataErrorState({required this.error}) : super(albumList: []);
}
