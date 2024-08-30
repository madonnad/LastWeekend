import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CustomCamPreview extends StatefulWidget {
  final CameraController controller;
  final double maxZoom;
  final double minZoom;
  const CustomCamPreview(
      {super.key,
      required this.controller,
      required this.maxZoom,
      required this.minZoom});

  @override
  State<CustomCamPreview> createState() => _CustomCamPreviewState();
}

class _CustomCamPreviewState extends State<CustomCamPreview> {
  double currentZoom = 1;
  double previousScale = 1;

  @override
  void initState() {
    super.initState();
  }

  void pinchEnd(ScaleEndDetails details) async {
    setState(() {
      previousScale = 1;
    });
  }

  void pinchUpdate(ScaleUpdateDetails details) async {
    double newScale = 0;
    double newZoom = 0;
    print(details.scale);

    if (details.scale == 1) return;

    newScale = details.scale - previousScale;
    if (newScale < 1) {
      newScale = newScale * 5;
    }
    newZoom = currentZoom + newScale;

    if (newZoom > widget.maxZoom) {
      newZoom = widget.maxZoom;
    }

    if (newZoom < widget.minZoom) {
      newZoom = widget.minZoom;
    }

    setState(() {
      currentZoom = newZoom;
      previousScale = details.scale;
    });

    await widget.controller.setZoomLevel(currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        //width: size.width,
        //height: size.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: GestureDetector(
          onScaleEnd: pinchEnd,
          onScaleUpdate: pinchUpdate,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: SizedBox(
              width: 100,
              child: CameraPreview(widget.controller),
            ),
          ),
        ),
      ),
    );
  }
}
