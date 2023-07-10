import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_photo/models/album.dart';

part 'user_data_event.dart';
part 'user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  UserDataBloc() : super(UserDataEmptyState()) {
    on<UserDataEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
