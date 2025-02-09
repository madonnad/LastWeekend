import 'dart:async';

import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/photo.dart';

class ShutterButton extends StatefulWidget {
  final CameraController controller;

  const ShutterButton({super.key, required this.controller});

  @override
  State<ShutterButton> createState() => _ShutterButtonState();
}

class _ShutterButtonState extends State<ShutterButton> {
  double shutterSize = 75;
  double scale = 1;
  // final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  // late DeviceOrientation orientation = DeviceOrientation.portraitUp;

  void shutterPressDown(TapDownDetails details) {
    setState(() {
      scale = 0.65;
    });
  }

  void animationEnd() {
    HapticFeedback.selectionClick();
    setState(() {
      scale = 1;
    });
  }

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
                capturedAt: DateTime.now(),
                albumID: selectedAlbum.albumId,
                type: UploadType.snap);
          } else {
            capImage = CapturedImage(
              imageXFile: picture,
              capturedAt: DateTime.now(),
              addToRecap: true,
              type: UploadType.snap,
            );
          }
          context.read<CameraCubit>().addPhotoToList(capImage);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 0,
          ),
          child: GestureDetector(
            onTap: selectedAlbum != null
                ? () async {
                    HapticFeedback.selectionClick();
                    XFile picture = await widget.controller.takePicture();

                    addPhotoToCubit(picture);
                  }
                : null,
            onTapDown: shutterPressDown,
            child: Container(
              width: shutterSize,
              height: shutterSize,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                //color: Colors.white.withOpacity(.5),
                borderRadius: BorderRadius.circular(shutterSize),
                border: Border.all(
                  color: Colors.white,
                  width: 5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 110),
                curve: Curves.easeIn,
                onEnd: animationEnd,
                child: Container(
                  width: shutterSize,
                  height: shutterSize,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(shutterSize),
                    // border: Border.all(
                    //   color: Colors.white54,
                    //   width: 8,
                    //   strokeAlign: BorderSide.strokeAlignOutside,
                    // ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
