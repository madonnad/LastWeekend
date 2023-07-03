import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

import '../models/user.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    User appUser = BlocProvider.of<AppBloc>(context).state.user;

    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (appUser != User.empty) {
          Navigator.of(context).pushReplacementNamed('home');
        } else if (appUser == User.empty) {
          Navigator.of(context).pushReplacementNamed('login');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
