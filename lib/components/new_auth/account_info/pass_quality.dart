import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class PassQuality extends StatelessWidget {
  final bool uppercase;
  final bool lowercase;
  final bool charOrDig;
  final bool length;
  const PassQuality({
    super.key,
    required this.uppercase,
    required this.lowercase,
    required this.charOrDig,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Must contain:",
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              fontSize: 14,
              color: Color.fromRGBO(242, 243, 247, 1),
              fontWeight: FontWeight.w800,
            ),
          ),
          Gap(5),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: uppercase
                        ? Color.fromRGBO(92, 184, 92, 1)
                        : Color.fromRGBO(242, 243, 247, .75),
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 5)),
                TextSpan(
                  text: "One uppercase letter",
                  style: GoogleFonts.lato(
                    color: uppercase
                        ? Color.fromRGBO(92, 184, 92, 1)
                        : Color.fromRGBO(242, 243, 247, .75),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Gap(3),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: lowercase
                        ? Color.fromRGBO(92, 184, 92, 1)
                        : Color.fromRGBO(242, 243, 247, .75),
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 5)),
                TextSpan(
                  text: "One lowercase letter",
                  style: GoogleFonts.lato(
                    color: lowercase
                        ? Color.fromRGBO(92, 184, 92, 1)
                        : Color.fromRGBO(242, 243, 247, .75),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Gap(3),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: charOrDig
                        ? Color.fromRGBO(92, 184, 92, 1)
                        : Color.fromRGBO(242, 243, 247, .75),
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 5)),
                TextSpan(
                  text: "One number or character !@#\$%^&*",
                  style: GoogleFonts.lato(
                    color: charOrDig
                        ? Color.fromRGBO(92, 184, 92, 1)
                        : Color.fromRGBO(242, 243, 247, .75),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Gap(3),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: length
                        ? Color.fromRGBO(92, 184, 92, 1)
                        : Color.fromRGBO(242, 243, 247, .75),
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 5)),
                TextSpan(
                  text: "At least 8 characters long",
                  style: GoogleFonts.lato(
                    color: length
                        ? Color.fromRGBO(92, 184, 92, 1)
                        : Color.fromRGBO(242, 243, 247, .75),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
