import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingListItem extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final VoidCallback navigator;
  const SettingListItem({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigator,
      child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.josefinSans(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
