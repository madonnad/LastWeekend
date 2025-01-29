import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_frame_comp/image_frame_dialog/delete_image_dialog.dart';
import 'package:shared_photo/components/image_frame_comp/image_frame_dialog/move_album_from_image_modal.dart';
import 'package:shared_photo/models/album.dart';

class MoreImageOptsDialog extends StatelessWidget {
  final bool canSave;

  const MoreImageOptsDialog({super.key, required this.canSave});

  @override
  Widget build(BuildContext context) {
    String userID = context.read<AppBloc>().state.user.id;
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, albumState) {
        return BlocBuilder<ImageFrameCubit, ImageFrameState>(
          builder: (context, state) {
            bool saveAvail = canSave && !state.loading;
            bool imageOwner = state.image.owner == userID;
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
                borderRadius: BorderRadius.circular(5),
              ),
              children: [
                DialogOptionItem(
                  onPressed: () => saveAvail
                      ? context.read<ImageFrameCubit>().downloadImageToDevice()
                      : null,
                  text: "Save Image",
                  textColor:
                      saveAvail ? Colors.white : Colors.white.withOpacity(.35),
                  showLoading: state.loading,
                ),
                showSwap
                    ? DialogOptionItem(
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
                        text: "Move Album",
                        textColor: Colors.white,
                      )
                    : const SizedBox.shrink(),
                imageOwner
                    ? DialogOptionItem(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (ctx) {
                              return BlocProvider.value(
                                value: context.read<AlbumFrameCubit>(),
                                child: DeleteImageDialog(),
                              );
                            },
                          );
                        },
                        text: "Delete Image",
                        textColor: Colors.white,
                      )
                    : const SizedBox.shrink()
              ],
            );
          },
        );
      },
    );
  }
}

class DialogOptionItem extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final bool? showLoading;
  const DialogOptionItem({
    super.key,
    required this.onPressed,
    required this.text,
    required this.textColor,
    this.showLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.montserrat(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          showLoading != null
              ? Expanded(
                  child: Row(
                    children: [
                      const Spacer(),
                      showLoading!
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
