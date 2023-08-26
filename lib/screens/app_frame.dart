import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/components/app_comp/nav_bar.dart';
import 'package:shared_photo/repositories/data_repository.dart';
import 'package:shared_photo/screens/feed.dart';
import 'package:shared_photo/screens/profile.dart';
import 'package:shared_photo/screens/search.dart';

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
          create: (context) => FeedBloc(
            appBloc: BlocProvider.of<AppBloc>(context),
            dataRepository: context.read<DataRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<AppFrameCubit, AppFrameState>(
          builder: (context, state) {
            return PageView(
              controller: state.appFrameController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const FeedScreen(),
                const SearchScreen(),
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
