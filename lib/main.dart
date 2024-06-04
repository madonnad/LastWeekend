import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/firebase_notifications_cubit.dart';
import 'package:shared_photo/firebase_options.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/notification_repository/notification_repository.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/router/generate_route.dart';
import 'package:shared_photo/screens/auth_frame.dart';
import 'package:shared_photo/screens/loading.dart';
import 'package:shared_photo/screens/app_frame.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final cameras = await availableCameras();

  runApp(MainApp(
    cameras: cameras,
    settings: settings,
  ));
}

class MainApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  final NotificationSettings settings;
  const MainApp({
    required this.cameras,
    required this.settings,
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
                      create: (context) => RealtimeRepository(
                        user: context.read<AppBloc>().state.user,
                      ),
                    ),
                    RepositoryProvider(
                      create: (context) => NotificationRepository(
                        realtimeRepository: context.read<RealtimeRepository>(),
                        user: context.read<AppBloc>().state.user,
                      ),
                    ),
                    RepositoryProvider(
                      lazy: false,
                      create: (context) => FirebaseNotificationsCubit(
                        user: context.read<AppBloc>().state.user,
                        settings: settings,
                      ),
                    ),
                    RepositoryProvider(
                      lazy: false,
                      create: (context) => DataRepository(
                        realtimeRepository: context.read<RealtimeRepository>(),
                        notificationRepository:
                            context.read<NotificationRepository>(),
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
            return const AppFrame();
          } else if (state is LoadingState) {
            return const LoadingScreen();
          } else {
            return const AuthFrame();
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
