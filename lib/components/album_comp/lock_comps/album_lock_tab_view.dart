import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/empty_album_unlock.dart';
import 'package:shared_photo/components/album_comp/lock_comps/album_lock_tab_bar.dart';
import 'package:shared_photo/components/album_comp/lock_comps/lock_timeline_page.dart';

class AlbumLockTabView extends StatelessWidget {
  const AlbumLockTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
        builder: (context, state) {
          return state.images.isNotEmpty
              ? DefaultTabController(
                  length: 1,
                  animationDuration: const Duration(milliseconds: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: AlbumLockTabBar(),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            if (details.delta.dx > 7) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              LockTimelinePage(album: state.album),
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
    );
  }
}
