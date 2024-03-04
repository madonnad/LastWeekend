import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/invite_comps/invite_page.dart';
import 'package:shared_photo/components/album_comp/lock_comps/album_lock_tab_view.dart';
import 'package:shared_photo/components/album_comp/util_comps/album_appbar_title.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/album_reveal_tab_view.dart';
import 'package:shared_photo/components/album_comp/unlock_comps/album_unlock_tab_view.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

class AlbumFrame extends StatelessWidget {
  final Arguments arguments;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];

  AlbumFrame({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlbumFrameCubit(
        album: arguments.album,
        dataRepository: context.read<DataRepository>(),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
            builder: (context, state) {
              return AlbumAppBarTitle(album: state.album);
            },
          ),
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 7) {
              Navigator.of(context).pop();
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Invite",
                      style: GoogleFonts.josefinSans(
                        color: arguments.album.phase == AlbumPhases.invite
                            ? Colors.white
                            : const Color.fromRGBO(125, 125, 125, 1),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Unlock",
                      style: GoogleFonts.josefinSans(
                        color: arguments.album.phase == AlbumPhases.unlock
                            ? Colors.white
                            : const Color.fromRGBO(125, 125, 125, 1),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Lock",
                      style: GoogleFonts.josefinSans(
                        color: arguments.album.phase == AlbumPhases.lock
                            ? Colors.white
                            : const Color.fromRGBO(125, 125, 125, 1),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Reveal",
                      style: GoogleFonts.josefinSans(
                        color: arguments.album.phase == AlbumPhases.reveal
                            ? Colors.white
                            : const Color.fromRGBO(125, 125, 125, 1),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
              BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                builder: (context, state) {
                  switch (state.album.phase) {
                    case AlbumPhases.reveal:
                      return const AlbumRevealTabView();
                    case AlbumPhases.invite:
                      return const InvitePage();
                    case AlbumPhases.unlock:
                      return const AlbumUnlockTabView();
                    case AlbumPhases.lock:
                      return const AlbumLockTabView();
                    default:
                      return const Placeholder();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
