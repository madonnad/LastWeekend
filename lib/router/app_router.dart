import 'package:flutter/material.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/screens/home.dart';
import 'package:shared_photo/screens/login.dart';

List<Page> onGenerateAppPages(AppState state, List<Page> pages) {
  switch (state) {
    case AuthenticatedState():
      return [const MaterialPage(child: HomeScreen())];
    case UnauthenticatedState():
      return [const MaterialPage(child: LoginScreen())];
  }
}
