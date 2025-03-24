import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_frame_comp/image_frame_dialog/more_img_opts_dialog.dart';
import 'package:shared_photo/models/album.dart';

class ImageFrameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String dateString;
  final String timeString;
  const ImageFrameAppBar(
      {super.key, required this.dateString, required this.timeString});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        bool canSave = (state.album.phase != AlbumPhases.reveal &&
                context.read<AppBloc>().state.user.id ==
                    state.selectedImage!.owner) ||
            state.album.phase == AlbumPhases.reveal;
        return AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                dateString,
                style: GoogleFonts.lato(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                timeString,
                style: GoogleFonts.lato(
                  color: Colors.white70,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (ctx) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<AlbumFrameCubit>(),
                      ),
                      BlocProvider.value(
                        value: context.read<ImageFrameCubit>(),
                      ),
                    ],
                    child: MoreImageOptsDialog(
                      canSave: canSave,
                    ),
                  );
                },
              ),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
