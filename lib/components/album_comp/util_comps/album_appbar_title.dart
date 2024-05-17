import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';

class AlbumAppBarTitle extends StatelessWidget implements PreferredSizeWidget {
  const AlbumAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        return AppBar(
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          title: Text(
            state.album.albumName,
            style: GoogleFonts.josefinSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    titleTextStyle: GoogleFonts.josefinSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                    title: Center(
                      child: Text(
                        state.album.albumName,
                      ),
                    ),
                    children: [
                      SimpleDialogOption(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.white54,
                                ),
                              ),
                              TextSpan(
                                text: "  ",
                                style: GoogleFonts.josefinSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: state.album.fullName,
                                style: GoogleFonts.josefinSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SimpleDialogOption(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Icons.groups,
                                  size: 20,
                                  color: Colors.white54,
                                ),
                              ),
                              TextSpan(
                                text: "  ",
                                style: GoogleFonts.josefinSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: state.album.guests.length.toString(),
                                style: GoogleFonts.josefinSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
