import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/components/app_comp/nav_bar.dart';
import 'package:shared_photo/screens/feed.dart';
import 'package:shared_photo/screens/profile.dart';
import 'package:shared_photo/screens/search.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppFrameCubit(),
      child: Scaffold(
        body: BlocBuilder<AppFrameCubit, AppFrameState>(
          builder: (context, state) {
            return PageView(
              controller: state.appFrameController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                FeedScreen(),
                SearchScreen(),
                ProfileScreen(),
              ],
            );
          },
        ),
        bottomNavigationBar: const LwNavBar(),
      ),
    );
  }
}
