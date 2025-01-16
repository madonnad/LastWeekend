import 'package:flutter/material.dart';

class HiddenImage extends StatelessWidget {
  final double fontSize;
  final double borderRadius;
  const HiddenImage(
      {super.key, required this.fontSize, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(44, 44, 44, .75),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        "🫣",
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
