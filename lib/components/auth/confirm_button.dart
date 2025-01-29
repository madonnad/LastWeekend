import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onTap;
  const ConfirmButton(
      {super.key, required this.buttonText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: onTap != null
              ? const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 205, 178, 1),
                    Color.fromRGBO(255, 180, 162, 1),
                    Color.fromRGBO(229, 152, 155, 1),
                    Color.fromRGBO(181, 131, 141, 1),
                    Color.fromRGBO(109, 104, 117, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 205, 178, .5),
                    Color.fromRGBO(255, 180, 162, .5),
                    Color.fromRGBO(229, 152, 155, .5),
                    Color.fromRGBO(181, 131, 141, .5),
                    Color.fromRGBO(109, 104, 117, .5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.montserrat(
              color: onTap != null ? Colors.white : Colors.white54,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
