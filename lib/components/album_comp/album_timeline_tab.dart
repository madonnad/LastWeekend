import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/album_bloc.dart';
import 'package:shared_photo/components/album_comp/invite_comps/invite_timeline_tab.dart';
import 'package:shared_photo/components/album_comp/lock_comps/lock_timeline_tab.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/reveal_timeline_tab.dart';
import 'package:shared_photo/components/album_comp/unlock_comps/unlock_timeline_tab.dart';
import 'package:shared_photo/models/album.dart';

class AlbumTimelineTab extends StatelessWidget {
  const AlbumTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        switch (state.album.phase) {
          case AlbumPhases.invite:
            return const InviteTimelineTab();
          case AlbumPhases.unlock:
            return const UnlockTimelineTab();
          case AlbumPhases.lock:
            return const LockTimelineTab();
          case AlbumPhases.reveal:
            return const RevealTimelineTab();
          default:
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
        }
      },
    );
  }
}
