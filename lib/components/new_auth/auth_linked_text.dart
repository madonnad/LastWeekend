import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthLinkedText extends StatelessWidget {
  final String linkText;
  final VoidCallback onTap;
  const AuthLinkedText(
      {super.key, required this.linkText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          linkText,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(108, 108, 108, 1),
          ),
        ),
      ),
    );
  }
}
