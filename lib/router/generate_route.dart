import 'package:flutter/material.dart';
import 'package:shared_photo/models/route_arguments.dart';
import 'package:shared_photo/screens/album_frame.dart';
import 'package:shared_photo/screens/album_create/album_create_modal.dart';
import 'package:shared_photo/screens/create_account_auth.dart';
import 'package:shared_photo/screens/feed.dart';
import 'package:shared_photo/screens/auth.dart';
import 'package:shared_photo/screens/profile.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const AuthScreen());
    case '/create-account-auth':
      return MaterialPageRoute(builder: (context) => const NewUserOnboarding());
    case '/home':
      return MaterialPageRoute(builder: (context) => const FeedScreen());
    case 'profile':
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    case '/create-album':
      return MaterialPageRoute(builder: (context) => const AlbumCreateModal());
    case '/album':
      RouteArguments arguments = settings.arguments as RouteArguments;
      return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (context, _, __) => AlbumFrame(arguments: arguments),
        transitionsBuilder: (context, a, b, c) {
          return FadeTransition(
            opacity: a,
            child: c,
          );
        },
      );
    default:
      return MaterialPageRoute(builder: (context) => const AuthScreen());
  }
}
