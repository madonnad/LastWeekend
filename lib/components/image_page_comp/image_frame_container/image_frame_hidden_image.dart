import 'package:flutter/material.dart';

class ImageFrameHiddenImage extends StatelessWidget {
  const ImageFrameHiddenImage({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(44, 44, 44, .75),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "🫣",
          style: TextStyle(fontSize: 55),
        ),
      ),
    );
  }
}
