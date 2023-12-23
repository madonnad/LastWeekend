import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/active_album_dropdown.dart';
import 'package:shared_photo/components/camera_comp/captured_preview_listview.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({
    super.key,
    required this.cameras,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool isCameraBack = false;

  @override
  void initState() {
    super.initState();
    CameraDescription camera = widget.cameras.isNotEmpty
        ? widget.cameras[0]
        : const CameraDescription(
            name: 'empty',
            lensDirection: CameraLensDirection.back,
            sensorOrientation: 0,
          );
    controller = CameraController(
      camera,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          case 'Cannot Record':
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void changeCameraDirection() async {
    setState(() {
      isCameraBack = !isCameraBack;
    });

    int cameraSelect = isCameraBack ? 1 : 0;

    controller = CameraController(
      widget.cameras[cameraSelect],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await controller.initialize();

    if (mounted) {
      setState(() {
        controller;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addPhotoToCubit(XFile picture) async {
      context.read<CameraCubit>().addPhotoToList(picture);
    }

    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        (controller.value.isInitialized)
            ? SizedBox(
                width: size.width,
                height: size.height,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: 100,
                    child: CameraPreview(controller),
                  ),
                ),
              )
            : Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
        Positioned(
          top: 125, // Adjust as needed
          left: MediaQuery.of(context).size.width * .75, // Adjust as needed
          right: 0, // Adjust as needed
          bottom: 50, // Adjust as needed
          child: const CapturedPreviewListView(),
        ),
        const Positioned(
          top: 100, // Adjust as needed
          left: 0, // Adjust as needed
          right: 0, // Adjust as needed
          child: Center(
            child: ActiveAlbumDropdown(
              opacity: .25,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * .75,
          left: 0,
          right: 0,
          child: Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () => changeCameraDirection(),
                child: const Icon(
                  Icons.flip_camera_ios_sharp,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: () async {
                    HapticFeedback.heavyImpact();
                    XFile picture = await controller.takePicture();

                    addPhotoToCubit(picture);
                  },
                  child: Container(
                    height: 85,
                    width: 85,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(85),
                      border: Border.all(
                        color: Colors.black87,
                        width: 8,
                      ),
                      color: Colors.white.withOpacity(.25),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.flash_off,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

/*

 child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                    ),

(!controller.value.isInitialized)
? Container(color: Colors.black)
    : Stack(
alignment: Alignment.center,
children: [
Container(child: CameraPreview(controller)),
Icon(Icons.flip_camera_ios_sharp),
],
);*/
