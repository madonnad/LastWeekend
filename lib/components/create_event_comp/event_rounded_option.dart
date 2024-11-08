import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventRoundedOption extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;
  const EventRoundedOption({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(44, 44, 44, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Color.fromRGBO(181, 131, 141, 1)
                : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
