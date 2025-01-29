import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/empty_album_unlock.dart';
import 'package:shared_photo/components/album_comp/unlock_comps/unlock_timeline_page.dart';
import 'package:shared_photo/components/album_comp/util_comps/forgot_shot_fab.dart';

class AlbumUnlockTabView extends StatelessWidget {
  const AlbumUnlockTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
        builder: (context, state) {
          return state.images.isNotEmpty
              ? Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              if (details.delta.dx > 7) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: UnlockTimelinePage(album: state.album),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 50,
                      right: 16,
                      child: ForgotShotFab(album: state.album),
                    ),
                  ],
                )
              : EmptyAlbumView(
                  isUnlockPhase: true,
                  album: state.album,
                );
        },
      ),
    );
  }
}
