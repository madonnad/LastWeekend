import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DurationItem extends StatelessWidget {
  final String? number;
  final String durationString;
  final int item;
  const DurationItem({
    super.key,
    this.number,
    required this.durationString,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = item == 1;
    return Container(
      padding: isSelected ? const EdgeInsets.all(2) : EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 205, 178, 1),
            Color.fromRGBO(255, 180, 162, 1),
            Color.fromRGBO(229, 152, 155, 1),
            Color.fromRGBO(181, 131, 141, 1),
            Color.fromRGBO(109, 104, 117, 1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(19, 19, 19, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            number != null
                ? ShaderMask(
                    shaderCallback: (bounds) {
                      return const LinearGradient(
                        tileMode: TileMode.mirror,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(255, 205, 178, 1),
                          Color.fromRGBO(255, 180, 162, 1),
                          Color.fromRGBO(229, 152, 155, 1),
                          Color.fromRGBO(181, 131, 141, 1),
                          Color.fromRGBO(109, 104, 117, 1),
                        ],
                      ).createShader(bounds);
                    },
                    child: Text(
                      number!,
                      style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        height: 0,
                        fontSize: 28,
                      ),
                    ),
                  )
                : const SizedBox(height: 0),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    tileMode: TileMode.mirror,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(255, 205, 178, 1),
                      Color.fromRGBO(255, 180, 162, 1),
                      Color.fromRGBO(229, 152, 155, 1),
                      Color.fromRGBO(181, 131, 141, 1),
                      Color.fromRGBO(109, 104, 117, 1),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  durationString.toUpperCase(),
                  style: GoogleFonts.josefinSans(
                    color: Colors.white,
                    height: 0,
                    fontSize: 16,
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
