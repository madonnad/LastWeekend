import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileFrame extends StatelessWidget {
  const EditProfileFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.josefinSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 28,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: const [],
        ),
      ),
    );
  }
}
