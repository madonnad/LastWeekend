import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyListComponent extends StatelessWidget {
  final String listName;
  const EmptyListComponent({super.key, required this.listName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: Text(
          "No ${listName}s",
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.white30,
          ),
        ),
      ),
    );
  }
}
