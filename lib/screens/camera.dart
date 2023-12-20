import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
  bool isCameraBack = true;

  @override
  void initState() {
    super.initState();
    CameraDescription camera = widget.cameras.isNotEmpty
        ? widget.cameras[1]
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
      ResolutionPreset.max,
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
    return (controller.value.description.name != "empty")
        ? Stack(
            fit: StackFit.passthrough,
            children: [
              CameraPreview(controller),
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
                      child: Container(
                        height: 85,
                        width: 85,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(85),
                          border: Border.all(
                            color: Colors.black54,
                            width: 4,
                          ),
                        ),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.flash_off,
                      color: Colors.white,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          )
        : Container(
            color: Colors.black,
            child: Text(
              "Hello",
              style: TextStyle(color: Colors.white),
            ),
          );
  }
}

/*(!controller.value.isInitialized)
? Container(color: Colors.black)
    : Stack(
alignment: Alignment.center,
children: [
Container(child: CameraPreview(controller)),
Icon(Icons.flip_camera_ios_sharp),
],
);*/
