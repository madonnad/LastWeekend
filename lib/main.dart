import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';
import 'package:shared_photo/router/generate_route.dart';
import 'package:shared_photo/screens/home.dart';
import 'package:shared_photo/screens/auth.dart';
import 'package:shared_photo/utils/api_key.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: dbUrl,
    anonKey: publicAnonKey,
  );

  final authenticationRepository = AuthenticationRepository();

  runApp(MainApp(authenticationRepository: authenticationRepository));
}

class MainApp extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  const MainApp(
      {required AuthenticationRepository authenticationRepository, super.key})
      : _authenticationRepository = authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) =>
            AppBloc(authenticationRepository: _authenticationRepository),
        child: const MainAppView(),
      ),
    );
  }
}

class MainAppView extends StatelessWidget {
  const MainAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is AuthenticatedState) {
            return const HomeScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
