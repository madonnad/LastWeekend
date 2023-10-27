import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/album_bloc.dart';
import 'package:shared_photo/components/album_comp/invite_comps/invite_everyone_tab.dart';
import 'package:shared_photo/components/album_comp/lock_comps/lock_everyone_tab.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/reveal_everyone_tab.dart';
import 'package:shared_photo/components/album_comp/unlock_comps/unlock_everyone_tab.dart';
import 'package:shared_photo/models/album.dart';

class AlbumEveryoneTab extends StatelessWidget {
  const AlbumEveryoneTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        switch (state.album.phase) {
          case AlbumPhases.invite:
            return const InviteEveryoneTab();
          case AlbumPhases.unlock:
            return const UnlockEveryoneTab();
          case AlbumPhases.lock:
            return const LockEveryoneTab();
          case AlbumPhases.reveal:
            return const RevealEveryoneTab();
          default:
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
        }
      },
    );
  }
}
