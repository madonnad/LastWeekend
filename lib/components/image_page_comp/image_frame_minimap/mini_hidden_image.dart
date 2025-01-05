import 'package:flutter/material.dart';

class MiniHiddenImage extends StatelessWidget {
  final bool isImage;
  const MiniHiddenImage({super.key, required this.isImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(44, 44, 44, 1),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isImage
              ? const Color.fromRGBO(255, 205, 178, 1)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: const Center(
        child: Text(
          "🫣",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
