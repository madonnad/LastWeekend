import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/components/app_comp/lw_global_bottom_app_bar.dart';
import 'package:shared_photo/components/app_comp/nav_bar.dart';
import 'package:shared_photo/repositories/go_repository.dart';
import 'package:shared_photo/screens/album_create/album_create_modal.dart';
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
            goRepository: context.read<GoRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
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
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.indigoAccent,
            /*gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.deepPurple,
                Colors.cyan,
              ],
            ),*/
          ),
          child: FloatingActionButton(
            elevation: 2,
            backgroundColor: Colors.transparent,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => showModalBottomSheet(
              enableDrag: false,
              isDismissible: false,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              context: context,
              builder: (BuildContext context) {
                return const AlbumCreateModal();
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: const LwGlobalBottomAppBar(),
      ),
    );
  }
}

//const LwNavBar(),
