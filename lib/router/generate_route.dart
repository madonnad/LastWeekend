import 'package:flutter/material.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/screens/album_create/album_create_modal.dart';
import 'package:shared_photo/screens/auth.dart';
import 'package:shared_photo/screens/new_album_frame.dart';
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
        pageBuilder: (context, _, __) => NewAlbumFrame(arguments: arguments),
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
