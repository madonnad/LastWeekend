import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
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

  @override
  void initState() {
    // double g = 9.81;
    // _streamSubscriptions.add(accelerometerEventStream().listen((event) {
    //   if (event.y > g / 2) {
    //     setState(() {
    //       orientation = DeviceOrientation.portraitUp;
    //     });
    //   } else if (event.y < -g / 2) {
    //     setState(() {
    //       orientation = DeviceOrientation.portraitDown;
    //     });
    //   } else if (event.x > g / 2) {
    //     setState(() {
    //       orientation = DeviceOrientation.landscapeLeft;
    //     });
    //   } else if (event.x < -g / 2) {
    //     setState(() {
    //       orientation = DeviceOrientation.landscapeRight;
    //     });
    //   }
    // }));

    super.initState();
  }

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

                    // final bytes = await File(picture.path).readAsBytes();
                    // img.Image? image = img.decodeImage(bytes);

                    // if (image == null ||
                    //     orientation == DeviceOrientation.portraitUp) {
                    //   addPhotoToCubit(picture);
                    //   return;
                    // }
                    // // Determine rotation based on orientation
                    // img.Image rotatedImage;
                    // switch (orientation) {
                    //   case DeviceOrientation.portraitUp:
                    //     // No rotation needed
                    //     rotatedImage = image;
                    //     break;
                    //   case DeviceOrientation.portraitDown:
                    //     // Rotate 180 degrees
                    //     rotatedImage = img.copyRotate(image, angle: 180);
                    //     break;
                    //   case DeviceOrientation.landscapeLeft:
                    //     // Rotate 90 degrees counterclockwise
                    //     rotatedImage = img.copyRotate(image, angle: -90);
                    //     break;
                    //   case DeviceOrientation.landscapeRight:
                    //     // Rotate 90 degrees clockwise
                    //     rotatedImage = img.copyRotate(image, angle: 90);
                    //     break;
                    // }

                    // // Encode the rotated image back to file
                    // File(picture.path)
                    //     .writeAsBytesSync(img.encodeJpg(rotatedImage));

                    // // Reassign the rotated image back to an XFile
                    // XFile rotatedPicture = XFile(picture.path);

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
                    color: Colors.black.withOpacity(0.25),
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
