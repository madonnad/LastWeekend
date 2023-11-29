import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAlbumButton extends StatelessWidget {
  const CreateAlbumButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 205, 178, 1),
            Color.fromRGBO(255, 180, 162, 1),
            Color.fromRGBO(229, 152, 155, 1),
            Color.fromRGBO(181, 131, 141, 1),
            Color.fromRGBO(109, 104, 117, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          "Create Album",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
