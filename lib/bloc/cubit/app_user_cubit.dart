import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_user_state.dart';

class UserCubitApp extends Cubit<AppUserState> {
  UserCubitApp() : super(AppUserInitial());
}
