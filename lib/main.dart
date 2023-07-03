import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';
import 'package:shared_photo/router/app_router.dart';
import 'package:shared_photo/router/generate_route.dart';
import 'package:shared_photo/screens/home.dart';
import 'package:shared_photo/screens/landing.dart';
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

  runApp(MainApp(authenticationRepository: authenticationRepository));
}

//final supabase = Supabase.instance.client;

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
    return const MaterialApp(
      home: LandingPage(),
      onGenerateRoute: onGenerateRoute,
    );
  }
}

/* FlowBuilder<AppState>(
        state: context.select((AppBloc bloc) => bloc.state),
        onGeneratePages: onGenerateAppPages,
      ), */