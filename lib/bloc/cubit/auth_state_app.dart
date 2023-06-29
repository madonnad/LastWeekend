part of 'auth_cubit_app.dart';

abstract class AuthStateApp {
  String? uid;
  AuthStateApp({this.uid});
}

class AuthLoadingState extends AuthStateApp {
  AuthLoadingState({super.uid});
}

class LoggedInState extends AuthStateApp {
  LoggedInState({super.uid});
}

class LogInScreenState extends AuthStateApp {
  LogInScreenState({super.uid});
}

class CreateAccountState extends AuthStateApp {
  CreateAccountState({super.uid});
}

class AddInfoState extends AuthStateApp {
  AddInfoState({super.uid});
}

class AddPhotoState extends AuthStateApp {
  AddPhotoState({super.uid});
}
