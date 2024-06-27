import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InviteListTitlebar extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const InviteListTitlebar({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.josefinSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const Icon(
          Icons.close,
          color: Colors.transparent,
        ),
      ],
    );
  }
}
