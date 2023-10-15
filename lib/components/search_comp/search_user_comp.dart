import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchUserComponent extends StatelessWidget {
  const SearchUserComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "Friends Name",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
