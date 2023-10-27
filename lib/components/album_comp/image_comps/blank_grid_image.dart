import 'package:flutter/material.dart';

class BlankGridImage extends StatelessWidget {
  const BlankGridImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        color: Colors.black87,
      ),
    );
  }
}
