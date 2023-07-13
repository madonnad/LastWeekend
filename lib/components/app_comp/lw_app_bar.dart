import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LwAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LwAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: 'last',
              style: GoogleFonts.josefinSans(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                  letterSpacing: -1.5),
            ),
            TextSpan(
              text: 'weekend',
              style: GoogleFonts.dancingScript(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final _appBar = AppBar();
  @override
  Size get preferredSize => _appBar.preferredSize;
}
