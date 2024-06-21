import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/move_album_modal.dart';
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
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return BlocProvider.value(
                            value: context.read<CameraCubit>(),
                            child: const MoveAlbumModal(),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.swap_horizontal_circle,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
