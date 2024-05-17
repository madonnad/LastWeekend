import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/captured_image.dart';

class EditImagePreview extends StatelessWidget {
  final CapturedImage selectedImage;
  final int selectedIndex;
  const EditImagePreview({
    super.key,
    required this.selectedImage,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 25),
      child: BlocBuilder<CameraCubit, CameraState>(
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height * .5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              image: state.photosTaken.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(
                        File(selectedImage.imageXFile.path),
                      ),
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<CameraCubit>().removePhotoFromList(
                            context,
                            state.selectedAlbumImageList[selectedIndex],
                          );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.cancel,
                        color: Colors.white70,
                        size: 30,
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () => context
                  //       .read<CameraCubit>()
                  //       .toggleMonthlyRecap(selectedImage),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: selectedImage.addToRecap
                  //           ? Colors.grey.withOpacity(1)
                  //           : Colors.grey.withOpacity(.5),
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(5.0),
                  //       child: Icon(
                  //         Icons.add,
                  //         color: selectedImage.addToRecap
                  //             ? Colors.white.withOpacity(1)
                  //             : Colors.white.withOpacity(.75),
                  //         size: 30,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
