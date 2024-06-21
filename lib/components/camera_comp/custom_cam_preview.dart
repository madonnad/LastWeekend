import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCamPreview extends StatefulWidget {
  final CameraController controller;
  const CustomCamPreview({super.key, required this.controller});

  @override
  State<CustomCamPreview> createState() => _CustomCamPreviewState();
}

class _CustomCamPreviewState extends State<CustomCamPreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.controller.description.sensorOrientation);
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 100,
          child: RotatedBox(
            quarterTurns:
                1 - widget.controller.description.sensorOrientation ~/ 90,
            child: CameraPreview(widget.controller),
          ),
        ),
      ),
    );
  }
}
