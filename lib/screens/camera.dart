import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/active_album_dropdown.dart';
import 'package:shared_photo/components/camera_comp/camera_image_stack.dart';
import 'package:shared_photo/components/camera_comp/camera_utils/camera_controls.dart';
import 'package:shared_photo/components/camera_comp/camera_utils/no_albums_overlay.dart';
import 'package:shared_photo/components/camera_comp/custom_cam_preview.dart';

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
  double minZoom = 0;
  double maxZoom = 1;
  double currentZoom = 0;

  @override
  void initState() {
    CameraDescription camera = widget.cameras.isNotEmpty
        ? widget.cameras[0]
        : const CameraDescription(
            name: 'empty',
            lensDirection: CameraLensDirection.back,
            sensorOrientation: 0,
          );
    controller = CameraController(
      camera,
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    super.initState();
    Future.microtask(() async {
      await initializeCameraController();
    });
  }

  Future<void> initializeCameraController() async {
    await controller.initialize();
    await lockOrientation();
    await setZoomValues();
    await controller.setFlashMode(FlashMode.auto);
  }

  Future<void> lockOrientation() async {
    await controller.lockCaptureOrientation();
  }

  Future<void> setZoomValues() async {
    await controller.getMinZoomLevel().then((value) => setState(() {
          minZoom = value;
          currentZoom = value;
        }));
    await controller.getMaxZoomLevel().then((value) => setState(() {
          maxZoom = value.floor().toDouble();
          if (maxZoom > 5) {
            maxZoom = 5;
          }
        }));

    await controller.setZoomLevel(currentZoom);
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void changeCameraDirection() async {
    setState(() {
      isCameraBack = !isCameraBack;
    });

    int cameraSelect = isCameraBack ? 1 : 0;

    controller = CameraController(
      widget.cameras[cameraSelect],
      ResolutionPreset.ultraHigh,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    if (mounted) {
      Future.microtask(() async {
        await initializeCameraController();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool minMaxSame =
        maxZoom < minZoom || currentZoom < minZoom || currentZoom > maxZoom;
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        final size = MediaQuery.of(context).size;
        return Stack(
          children: [
            (controller.value.isInitialized)
                ? SizedBox(
                    height: size.height,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).viewPadding.top,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onDoubleTap: () => changeCameraDirection(),
                            child: CustomCamPreview(
                              controller: controller,
                              maxZoom: maxZoom,
                              minZoom: minZoom,
                            ),
                          ),
                        ),
                        const SizedBox(height: 110),
                      ],
                    ),
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
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
              bottom: 110 + 25, //MediaQuery.of(context).size.height * .75,
              left: MediaQuery.of(context).size.width * .75,
              right: 0,
              child: const CameraImageStack(),
            ),
            Positioned(
                bottom: 110 + 25, //MediaQuery.of(context).size.height * .75,
                left: 0,
                right: 0,
                child: CameraControls(
                  controller: controller,
                  flipCamera: changeCameraDirection,
                )),
            const NoAlbumsOverlay(),
          ],
        );
      },
    );
  }
}
