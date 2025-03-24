import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CapturedListFab extends StatelessWidget {
  final int? count;
  final Color backgroundColor;
  final double horizontalPadding;
  final IconData icon;
  final Color contentColor;
  final double borderRadius;
  final VoidCallback onTap;
  const CapturedListFab({
    super.key,
    this.count,
    required this.backgroundColor,
    required this.horizontalPadding,
    required this.icon,
    required this.contentColor,
    required this.borderRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(
            child: Row(
              children: [
                Icon(icon, color: contentColor),
                count != null
                    ? Text(
                        count.toString(),
                        style: GoogleFonts.lato(
                          color: contentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
