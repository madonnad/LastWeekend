import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/bloc/cubit/new_app_frame_cubit.dart';
import 'package:shared_photo/components/new_app_frame/camera_nav_element.dart';
import 'package:shared_photo/components/new_app_frame/icon_nav_element.dart';
import 'package:shared_photo/components/new_app_frame/new_bottom_app_bar.dart';
import 'package:shared_photo/repositories/go_repository.dart';
import 'package:shared_photo/screens/new_feed.dart';

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
                  Center(
                    child: Container(
                      color: Colors.red,
                    ),
                  ),
                  Center(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                  Center(
                    child: Container(
                      color: Colors.black,
                    ),
                  )
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
