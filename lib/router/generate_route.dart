import 'package:flutter/material.dart';
import 'package:shared_photo/screens/create_account/create_account_auth.dart';
import 'package:shared_photo/screens/home.dart';
import 'package:shared_photo/screens/landing.dart';
import 'package:shared_photo/screens/login.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const LandingPage());
    case 'login':
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case '/create-account-auth':
      return MaterialPageRoute(
          builder: (context) => const CreateAccountAuthScreen());
    case '/home':
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    default:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
  }
}
