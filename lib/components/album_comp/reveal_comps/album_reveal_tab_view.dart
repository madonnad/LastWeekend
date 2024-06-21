import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/dashboard_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/empty_album_unlock.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/album_reveal_tab_bar.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/reveal_timeline_page.dart';
import 'package:shared_photo/components/album_comp/guests_page.dart';
import 'package:shared_photo/components/album_comp/popular_page.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/image_frame.dart';

class AlbumRevealTabView extends StatelessWidget {
  final Arguments arguments;
  const AlbumRevealTabView({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlbumFrameCubit, AlbumFrameState>(
      listener: (context, state) {
        if (state.images.isNotEmpty) {
          if (arguments.imageID != null) {
            int selectedIndex = context
                .read<AlbumFrameCubit>()
                .state
                .imageFrameTimelineList
                .indexWhere((element) => element.imageId == arguments.imageID);

            context
                .read<AlbumFrameCubit>()
                .initalizeImageFrameWithSelectedImage(selectedIndex);

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useRootNavigator: true,
              useSafeArea: true,
              builder: (ctx) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ImageFrameCubit(
                      dataRepository: context.read<DataRepository>(),
                      user: context.read<AppBloc>().state.user,
                      image: context
                          .read<AlbumFrameCubit>()
                          .state
                          .album
                          .images[selectedIndex],
                      albumID: arguments.albumID,
                    ),
                  ),
                  BlocProvider.value(
                    value: context.read<AlbumFrameCubit>(),
                  ),
                ],
                child: const ImageFrame(),
              ),
            );
          }
        }
      },
      child: Expanded(
        child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
          builder: (context, state) {
            return state.images.isNotEmpty
                ? DefaultTabController(
                    length: 3,
                    animationDuration: const Duration(milliseconds: 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: AlbumRevealTabBar(),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              if (details.delta.dx > 7) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: const TabBarView(
                              physics: NeverScrollableScrollPhysics(),
                              children: <Widget>[
                                PopularPage(),
                                GuestsPage(),
                                RevealTimelinePage(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : EmptyAlbumView(
                    isUnlockPhase: false,
                    album: state.album,
                  );
          },
        ),
      ),
    );
  }
}
