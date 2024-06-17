import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/active_album_dropdown.dart';
import 'package:shared_photo/components/camera_comp/camera_utils/camera_controls.dart';
import 'package:shared_photo/components/camera_comp/camera_utils/no_albums_overlay.dart';
import 'package:shared_photo/components/camera_comp/captured_preview_listview.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/captured_edit_screen.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/photo.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
    final size = MediaQuery.of(context).size;

    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
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
                bottom: 125, //MediaQuery.of(context).size.height * .75,
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
