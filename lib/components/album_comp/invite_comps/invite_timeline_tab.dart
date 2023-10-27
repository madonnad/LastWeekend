import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InviteTimelineTab extends StatelessWidget {
  const InviteTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "is it party time yet? 🎉",
        style: GoogleFonts.poppins(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.black45,
        ),
      ),
    );
  }
}
