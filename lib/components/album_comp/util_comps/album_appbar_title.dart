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
          titleSpacing: 0,
          //leadingWidth: 25,
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
              fontSize: 20,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                '/album-detail',
                arguments: context.read<AlbumFrameCubit>(),
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
