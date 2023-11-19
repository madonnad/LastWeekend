import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyMonth extends StatelessWidget {
  final String month;
  final String year;
  const EmptyMonth({super.key, required this.month, required this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(25, 25, 25, 1),
      ),
      child: Center(
        child: Text(
          "$month\n$year",
          style: GoogleFonts.josefinSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white54,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
