import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogImageRow extends StatelessWidget {
  final String listText;
  final String url;
  final Map<String, String> headers;
  final bool showImage;
  const DialogImageRow({
    super.key,
    required this.listText,
    required this.url,
    required this.headers,
    required this.showImage,
  });

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
          child: showImage
              ? Container(
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
                )
              : Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(44, 44, 44, .75),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "🫣",
                    style: TextStyle(fontSize: 32),
                  ),
                ),
        )
      ],
    );
  }
}
