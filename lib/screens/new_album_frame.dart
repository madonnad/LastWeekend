import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/new_album_frame_cubit.dart';
import 'package:shared_photo/components/album2_comp/invite_comps/invite_page.dart';
import 'package:shared_photo/components/album2_comp/lock_comps/album_lock_tab_view.dart';
import 'package:shared_photo/components/album2_comp/util_comps/album_appbar_title.dart';
import 'package:shared_photo/components/album2_comp/reveal_comps/album_reveal_tab_view.dart';
import 'package:shared_photo/components/album2_comp/unlock_comps/album_unlock_tab_view.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';

class NewAlbumFrame extends StatelessWidget {
  final Arguments arguments;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];

  NewAlbumFrame({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewAlbumFrameCubit(album: arguments.album),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: AlbumAppBarTitle(
            arguments: arguments,
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
              BlocBuilder<NewAlbumFrameCubit, NewAlbumFrameState>(
                builder: (context, state) {
                  switch (state.album.phase) {
                    case AlbumPhases.reveal:
                      return AlbumRevealTabView(arguments: arguments);
                    case AlbumPhases.invite:
                      return InvitePage(arguments: arguments);
                    case AlbumPhases.unlock:
                      return AlbumUnlockTabView(arguments: arguments);
                    case AlbumPhases.lock:
                      return AlbumLockTabView(arguments: arguments);
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
