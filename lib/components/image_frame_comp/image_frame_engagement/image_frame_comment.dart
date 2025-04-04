import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/models/comment.dart';

class ImageFrameComment extends StatelessWidget {
  final Map<String, String> headers;
  final Comment comment;
  const ImageFrameComment(
      {required this.headers, required this.comment, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
            foregroundImage: CachedNetworkImageProvider(
              comment.avatarReq540,
              headers: headers,
              errorListener: (_) {},
            ),
            radius: 14,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.fullName,
                      style: GoogleFonts.josefinSans(
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      comment.shortTime,
                      style: GoogleFonts.josefinSans(
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        comment.comment,
                        style: GoogleFonts.lato(
                          color: Colors.white.withOpacity(.9),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
