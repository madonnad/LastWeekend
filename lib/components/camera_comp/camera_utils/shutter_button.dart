import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/photo.dart';

class ShutterButton extends StatelessWidget {
  final CameraController controller;

  const ShutterButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        Album? selectedAlbum = state.selectedAlbum;

        Future<void> addPhotoToCubit(XFile picture) async {
          CapturedImage capImage;

          if (selectedAlbum != null) {
            capImage = CapturedImage(
              imageXFile: picture,
              albumID: selectedAlbum.albumId,
              type: UploadType.snap,
            );
          } else {
            capImage = CapturedImage(
              imageXFile: picture,
              addToRecap: true,
              type: UploadType.snap,
            );
          }
          context.read<CameraCubit>().addPhotoToList(capImage);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 15,
          ),
          child: InkWell(
            onTap: selectedAlbum != null
                ? () async {
                    HapticFeedback.heavyImpact();
                    XFile picture = await controller.takePicture();

                    addPhotoToCubit(picture);
                  }
                : null,
            child: Container(
              width: 85,
              height: 85,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.5),
                borderRadius: BorderRadius.circular(85),
                border: Border.all(
                  color: Colors.black,
                  width: 5,
                  strokeAlign: BorderSide.strokeAlignOutside,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
