import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeSlide extends StatelessWidget {
  final String name;
  const WelcomeSlide({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Center(
          child: Text(
            "Welcome $name!",
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 30),
        const Center(
          child: Text(
            "🥳",
            style: TextStyle(fontSize: 128),
          ),
        ),
        const Spacer(
          flex: 3,
        ),
      ],
    );
  }
}
