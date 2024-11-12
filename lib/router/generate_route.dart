import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/bloc/cubit/settings_cubit.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/screens/album_detail_frame.dart';
import 'package:shared_photo/screens/auth.dart';
import 'package:shared_photo/screens/album_frame.dart';
import 'package:shared_photo/screens/event_create/event_create_modal.dart';
import 'package:shared_photo/screens/friend_profile_frame.dart';
import 'package:shared_photo/screens/profile_guest_frame.dart';
import 'package:shared_photo/screens/settings/edit_profile_frame.dart';
import 'package:shared_photo/screens/settings_frame.dart';

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => const AuthScreen());
    case '/create-album':
      return MaterialPageRoute(builder: (context) => const EventCreateModal());
    case '/album':
      Arguments arguments = settings.arguments as Arguments;

      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, _, __) => MultiBlocProvider(
          providers: [
            // BlocProvider.value(
            //   value: AppFrameCubit(),
            // ),
            BlocProvider(
              create: (context) => AlbumFrameCubit(
                albumID: arguments.albumID,
                dataRepository: context.read<DataRepository>(),
                realtimeRepository: context.read<RealtimeRepository>(),
              ),
            ),
          ],
          child: AlbumFrame(arguments: arguments),
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
    case '/album-detail':
      AlbumFrameCubit albumFrameCubit = settings.arguments as AlbumFrameCubit;

      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, _, __) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: albumFrameCubit,
            ),
          ],
          child: const AlbumDetailFrame(),
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
    case '/guest':
      Map<String, dynamic> argMap = settings.arguments as Map<String, dynamic>;

      AlbumFrameCubit albumFrameCubit = argMap['albumFrameCubit'];
      String guestID = argMap['guestID'];

      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, _, __) => BlocProvider.value(
          value: albumFrameCubit,
          child: ProfileGuestFrame(guestID: guestID),
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
    case '/settings':
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, _, __) => BlocProvider(
          create: (context) => SettingsCubit(
            userRepository: context.read<UserRepository>(),
          ),
          child: const SettingsFrame(),
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
    case '/edit_profile':
      Map<String, dynamic> argMap = settings.arguments as Map<String, dynamic>;

      SettingsCubit settingsCubit = argMap['settingsCubit'];
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        pageBuilder: (context, _, __) => BlocProvider.value(
          value: settingsCubit,
          child: const EditProfileFrame(),
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
