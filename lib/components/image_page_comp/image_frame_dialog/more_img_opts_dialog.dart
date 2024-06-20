import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';

class MoreImageOptsDialog extends StatelessWidget {
  final bool canSave;
  const MoreImageOptsDialog({super.key, required this.canSave});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageFrameCubit, ImageFrameState>(
      builder: (context, state) {
        bool saveAvail = canSave && !state.loading;
        return SimpleDialog(
          title: const Text(
            "Options",
            textAlign: TextAlign.center,
          ),
          titleTextStyle: GoogleFonts.montserrat(
            color: Colors.white.withOpacity(.75),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
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
          ],
        );
      },
    );
  }
}
