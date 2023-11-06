import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final PageController albumFrameController;
  final List<CameraDescription> cameras;
  const CameraScreen({
    super.key,
    required this.albumFrameController,
    required this.cameras,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

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
    controller = CameraController(camera, ResolutionPreset.max);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios_new),
          onTap: () => widget.albumFrameController.animateToPage(
            0,
            curve: Curves.linear,
            duration: const Duration(
              milliseconds: 250,
            ),
          ),
        ),
      ),
      body: (!controller.value.isInitialized)
          ? const Center(
              child: Text("No Camera Detected"),
            )
          : CameraPreview(controller),
    );
  }
}
