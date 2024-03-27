import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/album_create/album_create_modal.dart';
import 'package:shared_photo/screens/auth.dart';
import 'package:shared_photo/screens/album_frame.dart';
import 'package:shared_photo/screens/friend_profile_frame.dart';
import 'package:shared_photo/screens/profile.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const AuthScreen());
    case 'profile':
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    case '/create-album':
      return MaterialPageRoute(builder: (context) => const AlbumCreateModal());
    case '/album':
      Arguments arguments = settings.arguments as Arguments;

      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, _, __) => AlbumFrame(arguments: arguments),
        transitionsBuilder: (context, a, b, c) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: a.drive(tween),
            child: c,
          );
        },
      );
    case '/friend':
      String lookupUid = settings.arguments as String;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, _, __) => BlocProvider(
          lazy: false,
          create: (context) => FriendProfileCubit(
            lookupUid: lookupUid,
            user: context.read<AppBloc>().state.user,
            dataRepository: context.read<DataRepository>(),
          ),
          child: const FriendProfileFrame(),
        ),
        transitionsBuilder: (context, a, b, c) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: a.drive(tween),
            child: c,
          );
        },
      );
    default:
      return MaterialPageRoute(builder: (context) => const AuthScreen());
  }
}
