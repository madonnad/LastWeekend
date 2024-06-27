import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CustomCamPreview extends StatefulWidget {
  final CameraController controller;
  const CustomCamPreview({super.key, required this.controller});

  @override
  State<CustomCamPreview> createState() => _CustomCamPreviewState();
}

class _CustomCamPreviewState extends State<CustomCamPreview> {
  bool firstFingerPressed = false;
  bool secondFingerPressed = false;
  @override
  void initState() {
    super.initState();
  }

  void toggleFirstFinger() {
    print("firstFingerPressed");
    setState(() {
      firstFingerPressed = !firstFingerPressed;
    });
  }

  void toggleSecondFinger(TapDownDetails? details) {
    print("secondFingerPressed");
    setState(() {
      secondFingerPressed = !secondFingerPressed;
    });
  }

  void printMoveUpdate(LongPressMoveUpdateDetails details) {
    setState(() {
      if (firstFingerPressed && secondFingerPressed) {
        print('something');
        print(details.localPosition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onDoubleTap: () => print("double tap"),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: 100,
            child: CameraPreview(widget.controller),
          ),
        ),
      ),
    );
  }
}
