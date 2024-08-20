import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/submit_image_button.dart';
import 'package:shared_photo/models/photo.dart';

class EmptyEditView extends StatelessWidget {
  const EmptyEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();

    void addListPhotos(List<XFile>? selectedImages) {
      if (selectedImages == null) return;

      context
          .read<CameraCubit>()
          .addListOfPhotosToList(selectedImages, UploadType.forgotShot);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Text(
              "No photos 😅",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(50),
            // GestureDetector(
            //   onTap: () async {
            //     List<XFile>? selectedImages =
            //         await imagePicker.pickMultiImage();
            //     addListPhotos(selectedImages);
            //   },
            //   child: IntrinsicWidth(
            //     stepWidth: 65,
            //     child: Container(
            //       height: 60,
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 20,
            //       ),
            //       alignment: Alignment.center,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         color: const Color.fromRGBO(44, 44, 44, 1),
            //       ),
            //       child: Text(
            //         "Add from Gallery 😅",
            //         style: GoogleFonts.montserrat(
            //           color: Colors.white,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w700,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const Spacer(),
            // const SubmitImageButton(),
            const SizedBox(height: 35)
          ],
        ),
      ),
    );
  }
}
