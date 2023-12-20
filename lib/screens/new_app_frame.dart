import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/bloc/cubit/new_app_frame_cubit.dart';
import 'package:shared_photo/components/new_app_frame/camera_nav_element.dart';
import 'package:shared_photo/components/new_app_frame/icon_nav_element.dart';
import 'package:shared_photo/components/new_app_frame/new_bottom_app_bar.dart';
import 'package:shared_photo/repositories/go_repository.dart';
import 'package:shared_photo/screens/camera.dart';
import 'package:shared_photo/screens/new_feed.dart';
import 'package:shared_photo/screens/new_profile.dart';

class NewAppFrame extends StatelessWidget {
  const NewAppFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NewAppFrameCubit(),
        ),
        BlocProvider(
          create: (context) => FeedBloc(
            appBloc: BlocProvider.of<AppBloc>(context),
            goRepository: context.read<GoRepository>(),
          ),
        ),
      ],
      child: BlocBuilder<NewAppFrameCubit, NewAppFrameState>(
        builder: (context, state) {
          final double devHeight = MediaQuery.of(context).size.height;
          return SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              extendBody: state.index == 2 ? true : false,
              resizeToAvoidBottomInset: true,
              backgroundColor: Colors.black,
              body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: state.pageController,
                children: [
                  Center(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  NewFeed(devHeight: devHeight),
                  BlocBuilder<AppBloc, AppState>(
                    builder: (context, state) {
                      AuthenticatedState appState = state as AuthenticatedState;
                      return CameraScreen(cameras: appState.cameras);
                    },
                  ),
                  Center(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  const NewProfileScreen()
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
