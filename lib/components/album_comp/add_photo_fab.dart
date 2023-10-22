import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPhotoFab extends StatelessWidget {
  const AddPhotoFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: FloatingActionButton.extended(
        elevation: 2,
        backgroundColor: Colors.indigoAccent,
        label: SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.photo_camera,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "add photo",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
