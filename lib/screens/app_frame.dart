import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/dashboard_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/bloc/cubit/search_cubit.dart';
import 'package:shared_photo/components/new_app_frame/new_bottom_app_bar.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/realtime_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/screens/camera.dart';
import 'package:shared_photo/screens/new_feed.dart';
import 'package:shared_photo/screens/profile_screen.dart';
import 'package:shared_photo/screens/notification_frame.dart';
import 'package:shared_photo/screens/search_frame.dart';
import 'package:shared_photo/screens/welcome_frame.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppFrameCubit(),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            dataRepository: context.read<DataRepository>(),
            user: context.read<AppBloc>().state.user,
          ),
        ),
        BlocProvider(
          create: (context) => DashboardBloc(
            dataRepository: context.read<DataRepository>(),
            user: context.read<AppBloc>().state.user,
          ),
        ),
        BlocProvider(
          create: (context) => FeedBloc(
            dataRepository: context.read<DataRepository>(),
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => CameraCubit(
            user: context.read<AppBloc>().state.user,
            dataRepository: context.read<DataRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(
            realtimeRepository: context.read<RealtimeRepository>(),
            user: context.read<AppBloc>().state.user,
          ),
        ),
      ],
      child: BlocBuilder<AppFrameCubit, AppFrameState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            bool newAccount = context.read<AppBloc>().state.user.newAccount;
            if (newAccount != false) {
              showModalBottomSheet(
                isScrollControlled: true,
                isDismissible: false,
                enableDrag: false,
                useSafeArea: true,
                context: context,
                builder: (context) => const WelcomeFrame(),
              );
            }
          });

          final double devHeight = MediaQuery.of(context).size.height;
          return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              extendBody: state.index == 2 ? true : false,
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: state.pageController,
                children: [
                  BlocProvider(
                    create: (context) => SearchCubit(
                      user: context.read<AppBloc>().state.user,
                    ),
                    child: const SearchFrame(),
                  ),
                  NewFeed(devHeight: devHeight),
                  BlocBuilder<AppBloc, AppState>(
                    builder: (context, state) {
                      AuthenticatedState appState = state as AuthenticatedState;
                      return CameraScreen(cameras: appState.cameras);
                    },
                  ),
                  const NotificationFrame(),
                  const ProfileScreen()
                ],
              ),
              bottomNavigationBar: const NewBottomAppBar(),
            ),
          );
        },
      ),
    );
  }
}
/**/
