import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/captured_image.dart';

class EditCaptionField extends StatelessWidget {
  final CapturedImage selectedImage;
  const EditCaptionField({super.key, required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return SizedBox(
          height: 70,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(19, 19, 19, 1),
            child: Center(
              child: TextField(
                controller: state.captionTextController,
                maxLines: null,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                onSubmitted: (_) => context
                    .read<CameraCubit>()
                    .updateImageCaption(selectedImage),
                onChanged: (_) {
                  Future.delayed(const Duration(milliseconds: 350));
                  context.read<CameraCubit>().updateImageCaption(selectedImage);
                },
                onTapOutside: (_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context.read<CameraCubit>().updateImageCaption(selectedImage);
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  hintText: "Add Caption",
                  hintStyle: GoogleFonts.josefinSans(
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(.75),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
