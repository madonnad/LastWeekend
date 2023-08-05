import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';
import 'package:shared_photo/repositories/data_repository.dart';
import 'package:shared_photo/router/generate_route.dart';
import 'package:shared_photo/screens/app_frame.dart';
import 'package:shared_photo/screens/auth.dart';
import 'package:shared_photo/screens/loading.dart';
import 'package:shared_photo/utils/api_key.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: dbUrl,
    anonKey: publicAnonKey,
  );

  final authenticationRepository = AuthenticationRepository();
  final dataRepository = DataRepository();

  runApp(MainApp(
    authenticationRepository: authenticationRepository,
    dataRepository: dataRepository,
  ));
}

class MainApp extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;
  final DataRepository _dataRepository;
  const MainApp(
      {required AuthenticationRepository authenticationRepository,
      required DataRepository dataRepository,
      super.key})
      : _authenticationRepository = authenticationRepository,
        _dataRepository = dataRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider.value(
          value: _dataRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppBloc(
              authenticationRepository: _authenticationRepository,
            ),
          ),
        ],
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo),
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.white, surfaceTintColor: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),
      ),
      home: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is AuthenticatedState) {
            return const AppFrame();
          } else if (state is CachedAuthenticatedState) {
            return const LoadingScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
