import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/go_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/router/generate_route.dart';
import 'package:shared_photo/screens/auth.dart';
import 'package:shared_photo/screens/loading.dart';
import 'package:shared_photo/screens/new_app_frame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final cameras = await availableCameras();

  runApp(MainApp(
    cameras: cameras,
  ));
}

class MainApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MainApp({
    required this.cameras,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(systemNavigationBarColor: Colors.black));
    return RepositoryProvider(
      create: (context) => Auth0Repository(),
      child: BlocProvider(
        create: (context) => AppBloc(
          auth0repository: context.read<Auth0Repository>(),
          cameras: cameras,
        ),
        child: BlocBuilder<AppBloc, AppState>(
          builder: (context, state) {
            switch (state.status) {
              case AppStatus.authenticated:
                return MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider(
                      lazy: false,
                      create: (context) => GoRepository(
                        user: context.read<AppBloc>().state.user,
                      ),
                    ),
                    RepositoryProvider(
                      lazy: false,
                      create: (context) => DataRepository(
                        user: context.read<AppBloc>().state.user,
                      ),
                    ),
                    RepositoryProvider(
                      create: (context) => UserRepository(
                        user: context.read<AppBloc>().state.user,
                      ),
                    ),
                  ],
                  child: const MainAppView(),
                );
              case AppStatus.unauthenticated:
                return const MainAppView();
            }
          },
        ),
      ),
    );
  }
}

class MainAppView extends StatelessWidget {
  const MainAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lwCustomTheme(),
      home: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is AuthenticatedState) {
            return const NewAppFrame();
          } else if (state is LoadingState) {
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

ThemeData lwCustomTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
    scaffoldBackgroundColor: Colors.white,
    splashFactory: NoSplash.splashFactory,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.black, surfaceTintColor: Colors.black),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
    ),
  );
}
