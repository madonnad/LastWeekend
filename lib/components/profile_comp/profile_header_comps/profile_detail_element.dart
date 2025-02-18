import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileDetailElement extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;
  const ProfileDetailElement({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(34, 34, 38, 1),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  Gap(3),
                  Text(
                    title.toUpperCase(),
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white54,
                      height: 1,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward,
                color: onTap != null ? Colors.white : Colors.transparent,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
