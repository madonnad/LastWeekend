import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendStatusButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;
  const FriendStatusButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.josefinSans(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
