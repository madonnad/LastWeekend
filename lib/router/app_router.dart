import 'package:flutter/material.dart';
import 'package:shared_photo/screens/create_account.dart';
import 'package:shared_photo/screens/create_account_personal_info.dart';
import 'package:shared_photo/screens/login.dart';
import 'package:shared_photo/screens/upload_profile_pic.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case '/create_account':
        return MaterialPageRoute(
          builder: (_) => CreateAccountScreen(),
        );
      case '/add_personal_info':
        return MaterialPageRoute(
          builder: (_) => CreateAccountPersonalInfoScreen(),
        );
      case '/add_profile_pic':
        return MaterialPageRoute(
          builder: (_) => const UploadProfilePictureScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
    }
  }
}
