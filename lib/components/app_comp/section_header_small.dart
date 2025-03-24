import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeaderSmall extends StatelessWidget {
  final String value;
  const SectionHeaderSmall(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.toUpperCase(),
      style: GoogleFonts.lato(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: const Color.fromRGBO(213, 213, 213, 1),
      ),
    );
  }
}
