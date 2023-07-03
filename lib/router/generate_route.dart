import 'package:flutter/material.dart';
import 'package:shared_photo/screens/create_account/create_account_auth.dart';
import 'package:shared_photo/screens/home.dart';
import 'package:shared_photo/screens/auth.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => AuthScreen());
    case '/create-account-auth':
      return MaterialPageRoute(
          builder: (context) => const CreateAccountAuthScreen());
    case '/home':
      return MaterialPageRoute(builder: (context) => const HomeScreen());
    default:
      return MaterialPageRoute(builder: (context) => AuthScreen());
  }
}
