import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnpublishedMonth extends StatelessWidget {
  final String month;
  final String year;
  const UnpublishedMonth({super.key, required this.month, required this.year});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(255, 205, 178, .5),
            Color.fromRGBO(255, 180, 162, .5),
            Color.fromRGBO(229, 152, 155, .5),
            Color.fromRGBO(181, 131, 141, .5),
            Color.fromRGBO(109, 104, 117, .5),
          ],
        ),
      ),
      child: Center(
        child: Text(
          "$month\n$year",
          style: GoogleFonts.josefinSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
