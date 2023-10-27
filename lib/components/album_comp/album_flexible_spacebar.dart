import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/album_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/album.dart';

class AlbumFlexibleSpacebar extends StatelessWidget {
  const AlbumFlexibleSpacebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        Album album = state.album;
        Map<String, String> header = context.read<AppBloc>().state.user.headers;
        return FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        album.albumName,
                        style: GoogleFonts.josefinSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: CachedNetworkImageProvider(
                                album.ownerImageURl,
                                headers: header),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Zoë",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.transparent,
                        side: BorderSide.none,
                        avatar: const Icon(
                          Icons.groups,
                          size: 12,
                          color: Colors.black,
                        ),
                        label: Text(
                          "20",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.transparent,
                        side: BorderSide.none,
                        avatar: const Icon(
                          Icons.remove_red_eye_outlined,
                          size: 12,
                          color: Colors.black,
                        ),
                        label: Text(
                          "just us",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.transparent,
                        side: BorderSide.none,
                        avatar: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 12,
                        ),
                        label: Text(
                          "100",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.transparent,
                        side: BorderSide.none,
                        avatar: const Icon(
                          Icons.arrow_circle_up_rounded,
                          color: Colors.black,
                          size: 12,
                        ),
                        label: Text(
                          "35",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const Flexible(
                      flex: 2,
                      child: SizedBox(),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
