import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/photo.dart';

class ImageFrameCaption extends StatelessWidget {
  final Map<String, String> headers;
  final Photo? selectedImage;
  final AlbumPhases phase;

  const ImageFrameCaption(
      {super.key,
      required this.headers,
      required this.selectedImage,
      required this.phase});

  @override
  Widget build(BuildContext context) {
    String userID = context.read<AppBloc>().state.user.id;

    bool showCaption = false;

    if (selectedImage != null) {
      showCaption =
          phase == AlbumPhases.reveal || (selectedImage!.owner == userID);
    }
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
                  state.image.avatarReq,
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
                bool captionPresent = true;

                if (state.image.imageCaption.isEmpty) {
                  captionPresent = false;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    captionPresent ? const Gap(0) : const Gap(10),
                    Text(
                      state.image.fullName,
                      style: GoogleFonts.josefinSans(
                        color: captionPresent ? Colors.white54 : Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    captionPresent
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          state.image.imageCaption,
                                          style: GoogleFonts.josefinSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    showCaption
                                        ? const SizedBox.shrink()
                                        : Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            height: 20,
                                            child: ClipRect(
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                    sigmaX: 2, sigmaY: 3),
                                                child: Container(
                                                  height: 20,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(height: 0)
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
