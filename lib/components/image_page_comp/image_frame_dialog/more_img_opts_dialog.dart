import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/move_album_from_image_modal.dart';
import 'package:shared_photo/models/album.dart';

class MoreImageOptsDialog extends StatelessWidget {
  final bool canSave;

  const MoreImageOptsDialog({super.key, required this.canSave});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, albumState) {
        return BlocBuilder<ImageFrameCubit, ImageFrameState>(
          builder: (context, state) {
            bool saveAvail = canSave && !state.loading;

            bool showSwap = albumState.album.phase != AlbumPhases.reveal &&
                state.image.owner == context.read<AppBloc>().state.user.id;

            return SimpleDialog(
              title: const Text(
                "Options",
                textAlign: TextAlign.center,
              ),
              titleTextStyle: GoogleFonts.montserrat(
                color: Colors.white.withOpacity(.75),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              children: [
                SimpleDialogOption(
                  onPressed: () => saveAvail
                      ? context.read<ImageFrameCubit>().downloadImageToDevice()
                      : null,
                  child: Row(
                    children: [
                      Text(
                        "Save Image",
                        style: GoogleFonts.montserrat(
                          color: saveAvail
                              ? Colors.white
                              : Colors.white.withOpacity(.35),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      state.loading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                showSwap
                    ? SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) => MoveAlbumFromImageModal(
                              albumID: albumState.album.albumId,
                              imageID: state.image.imageId,
                            ),
                          );
                        },
                        child: Text(
                          "Move Album",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        );
      },
    );
  }
}
