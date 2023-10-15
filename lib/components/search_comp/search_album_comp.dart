import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchAlbumComponent extends StatelessWidget {
  const SearchAlbumComponent({super.key});

  @override
  Widget build(BuildContext context) {
    double devHeight = MediaQuery.of(context).size.height;

    return Card(
      color: const Color.fromRGBO(225, 225, 225, 1),
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              width: devHeight * .06,
              height: devHeight * .06,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Album Name",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Album Owner",
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
