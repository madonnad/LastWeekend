import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogImageRow extends StatelessWidget {
  final String listText;
  final String url;
  final Map<String, String> headers;
  const DialogImageRow(
      {super.key,
      required this.listText,
      required this.url,
      required this.headers});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          listText,
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 20),
        AspectRatio(
          aspectRatio: 4 / 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  url,
                  headers: headers,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ],
    );
  }
}
