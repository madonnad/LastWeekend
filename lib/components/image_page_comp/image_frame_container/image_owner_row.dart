import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageOwnerRow extends StatelessWidget {
  final String fullName;
  final String imageAvatarUrl;
  final Map<String, String> headers;
  const ImageOwnerRow({
    super.key,
    required this.fullName,
    required this.imageAvatarUrl,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, 0.0),
                blurRadius: 15.0,
                color: Colors.black54,
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
            foregroundImage: CachedNetworkImageProvider(
              imageAvatarUrl,
              headers: headers,
            ),
            radius: 17,
          ),
        ),
        const Gap(10),
        Text(
          fullName,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            shadows: [
              const Shadow(
                offset: Offset(0.0, 0.0),
                blurRadius: 15.0,
                color: Colors.black54,
              ),
            ],
          ),
        )
      ],
    );
  }
}
