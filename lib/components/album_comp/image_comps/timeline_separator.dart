import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TimelineSeparator extends StatelessWidget {
  final String dateString;
  const TimelineSeparator({super.key, required this.dateString});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          dateString,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              thickness: 1,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
