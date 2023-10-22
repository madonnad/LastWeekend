import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlbumBottomAppBar extends StatelessWidget {
  const AlbumBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 3,
      color: Colors.white,
      surfaceTintColor: Colors.grey,
      shape: AutomaticNotchedShape(
        const RoundedRectangleBorder(),
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.lock_open_outlined,
                    size: 25,
                    color: Colors.indigoAccent,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "1d 15h 24m 30s",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
            )
          ],
        ),
      ),
    );
  }
}
