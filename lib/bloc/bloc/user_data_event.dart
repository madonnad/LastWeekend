part of 'user_data_bloc.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

final class UserDataRequested extends UserDataEvent {
  String uid;
  UserDataRequested({required this.uid});
}

final class RemoveUserData extends UserDataEvent {}
