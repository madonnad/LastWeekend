import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_user_cubit.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit_app.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';
import 'package:shared_photo/router/app_router.dart';
import 'package:shared_photo/screens/create_account.dart';
import 'package:shared_photo/screens/home_screen.dart';
import 'package:shared_photo/screens/login.dart';
import 'package:shared_photo/utils/api_key.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: dbUrl,
    anonKey: publicAnonKey,
  );

  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  runApp(MainApp(authenticationRepository: authenticationRepository));
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  const MainApp(
      {required AuthenticationRepository authenticationRepository, super.key})
      : _authenticationRepository = authenticationRepository;

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();

    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) =>
            AppBloc(authenticationRepository: _authenticationRepository),
        child: LoginScreen(),
      ),
    );
  }
}


/* return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubitApp>(
          create: (context) => AuthCubitApp(),
        ),
        BlocProvider<UserCubitApp>(
          create: (context) => UserCubitApp(),
        )
      ],
      child: MaterialApp(
          title: 'dvlpr',
          onGenerateRoute: appRouter.onGenerateRoute,
          home: BlocBuilder<AuthCubitApp, AuthStateApp>(
            builder: (context, state) {
              if (state is LoggedInState) {
                return const HomeScreen();
              } else if (state is CreateAccountState) {
                return CreateAccountScreen();
              } else if (state is AuthLoadingState) {
                return const CircularProgressIndicator();
              } else if (state is LogInScreenState) {
                return LoginScreen();
              } else {
                return LoginScreen();
              }
            },
          )),
    ); */