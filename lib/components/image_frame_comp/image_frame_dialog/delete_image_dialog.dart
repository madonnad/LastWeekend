import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';

class DeleteImageDialog extends StatelessWidget {
  const DeleteImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SimpleDialog(
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          titleTextStyle: GoogleFonts.montserrat(
            color: Colors.white.withOpacity(.75),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          title: Text(
            "Delete Image?",
            textAlign: TextAlign.center,
          ),
          insetPadding: EdgeInsets.zero,
          children: [
            Row(
              children: [
                Gap(10),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      context.read<AlbumFrameCubit>().deleteImageInAlbum();

                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(109, 104, 117, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Delete",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Gap(10),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(44, 44, 44, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Gap(10),
              ],
            ),
          ],
        ),
        BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
          builder: (context, state) {
            if (state.loading == true) {
              return Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const SizedBox(height: 0);
            }
          },
        ),
      ],
    );
  }
}
