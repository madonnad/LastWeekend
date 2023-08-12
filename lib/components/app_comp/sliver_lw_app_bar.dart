import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SliverLWAppBar extends StatelessWidget {
  const SliverLWAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Center(
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'last',
                style: GoogleFonts.josefinSans(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                    letterSpacing: -1.5),
              ),
              TextSpan(
                text: 'weekend',
                style: GoogleFonts.dancingScript(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
