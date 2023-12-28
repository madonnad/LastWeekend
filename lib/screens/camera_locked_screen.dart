import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraLockedScreen extends StatelessWidget {
  const CameraLockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Color.fromRGBO(16, 16, 16, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Albums Available",
              style: GoogleFonts.josefinSans(
                fontSize: 32,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
