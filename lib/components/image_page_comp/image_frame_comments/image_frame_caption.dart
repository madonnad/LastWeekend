import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';

class ImageFrameCaption extends StatelessWidget {
  final Map<String, String> headers;

  const ImageFrameCaption({
    required this.headers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        bottom: 10.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ImageFrameCubit, ImageFrameState>(
            builder: (context, state) {
              return CircleAvatar(
                backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
                foregroundImage: CachedNetworkImageProvider(
                  state.avatarReq,
                  headers: headers,
                ),
                radius: 20,
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: BlocBuilder<ImageFrameCubit, ImageFrameState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.fullName,
                      style: GoogleFonts.josefinSans(
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            state.imageCaption,
                            style: GoogleFonts.josefinSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
