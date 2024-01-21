import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class FloatingCommentContainer extends StatelessWidget {
  final Map<String, String> headers;
  const FloatingCommentContainer({required this.headers, super.key});

  @override
  Widget build(BuildContext context) {
    String avatarUrl = context.read<AppBloc>().state.user.avatarUrl;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(44, 44, 44, 1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black87,
              spreadRadius: 10,
              blurRadius: 10,
              offset: Offset(0, 0), // changes position of shadow
            )
          ],
        ),
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color.fromRGBO(25, 25, 25, 1),
                foregroundImage:
                    CachedNetworkImageProvider(avatarUrl, headers: headers),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  maxLines: null,
                  style: GoogleFonts.josefinSans(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add Comment",
                    hintStyle: GoogleFonts.josefinSans(
                      color: Colors.white70,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.comment_rounded,
                      color: Colors.white54,
                      size: 25,
                    ),
                    const Icon(
                      Icons.favorite_outline,
                      color: Colors.white54,
                      size: 25,
                    ),
                    Transform.rotate(
                      angle: (270 * math.pi) / 180,
                      child: const Icon(
                        Icons.label_important_outline,
                        color: Colors.white54,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
