import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InviteEveryoneTab extends StatelessWidget {
  const InviteEveryoneTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "almost ready! 🫣",
        style: GoogleFonts.poppins(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.black45,
        ),
      ),
    );
  }
}
