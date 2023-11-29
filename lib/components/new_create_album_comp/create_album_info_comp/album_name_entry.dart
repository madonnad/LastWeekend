import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumNameEntry extends StatelessWidget {
  const AlbumNameEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: TextEditingController(),
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "ALBUM NAME",
        hintStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white54),
      ),
    );
  }
}
