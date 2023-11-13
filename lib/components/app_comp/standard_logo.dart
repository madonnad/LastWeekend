import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StandardLogo extends StatelessWidget {
  const StandardLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'last',
            style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w100,
                letterSpacing: -1.5),
          ),
          TextSpan(
            text: 'weekend',
            style: GoogleFonts.dancingScript(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}
