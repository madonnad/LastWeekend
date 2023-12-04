import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalHeader extends StatelessWidget {
  final VoidCallback iconFunction;
  final String title;
  final Icon icon;
  const ModalHeader({
    super.key,
    required this.iconFunction,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 15,
          child: IconButton(
            splashColor: Colors.purple,
            onPressed: iconFunction,
            icon: icon,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
