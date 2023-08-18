import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyFriendsSection extends StatelessWidget {
  const EmptyFriendsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          "a party of one...?",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            color: Colors.black38,
          ),
        ),
      ),
    );
  }
}
