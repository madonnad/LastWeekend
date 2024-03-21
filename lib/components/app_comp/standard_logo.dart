import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StandardLogo extends StatelessWidget {
  final double fontSize;
  const StandardLogo({super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'last',
            style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w200,
                letterSpacing: -1.5),
          ),
          TextSpan(
            text: 'weekend',
            style: GoogleFonts.dancingScript(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
