import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyFeed extends StatelessWidget {
  const EmptyFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "No Albums in the Feed 😔",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(.85),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                "Follow someone or start an album to see them here!",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.white.withOpacity(.5),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
