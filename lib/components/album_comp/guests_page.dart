import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/image_components/guest_item_component.dart';
import 'package:shared_photo/models/guest.dart';
import 'package:shared_photo/models/photo.dart';

class GuestsPage extends StatelessWidget {
  const GuestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.only(top: 12),
          ),
          BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
            builder: (context, state) {
              List<String> idList = state.imagesGroupedByGuest.keys.toList();
              return SliverList.separated(
                itemCount: state.imagesGroupedByGuest.length,
                itemBuilder: (context, index) {
                  String id = idList[index];
                  int imagesToShow = 0;
                  List<Photo> guestsImages = [];
                  Guest? guest = state.album.guestMap[id];

                  if (state.imagesGroupedByGuest[id] != null) {
                    guestsImages = state.imagesGroupedByGuest[id]!;

                    imagesToShow = min(3, guestsImages.length);
                  }

                  Map<String, dynamic> argMap = {
                    'albumFrameCubit': context.read<AlbumFrameCubit>(),
                    'guestID': id,
                  };

                  return guest != null
                      ? GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed('/guest', arguments: argMap),
                          child: Container(
                            height: guestsImages.isNotEmpty ? 200 : null,
                            color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "lib/assets/placeholder.png"),
                                            foregroundImage:
                                                CachedNetworkImageProvider(
                                              guest.avatarReq540,
                                              headers: headers,
                                              errorListener: (_) {},
                                            ),
                                            radius: 20,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              guest.fullName,
                                              style: GoogleFonts.josefinSans(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                ),
                                guestsImages.isNotEmpty
                                    ? Expanded(
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: imagesToShow,
                                          itemBuilder: (context, item) {
                                            if (item == 0) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: GuestItemComponent(
                                                  image: guestsImages[item],
                                                  headers: headers,
                                                ),
                                              );
                                            }
                                            return GuestItemComponent(
                                              image: guestsImages[item],
                                              headers: headers,
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(width: 10);
                                          },
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          "No Photos Added",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white70,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: Divider(
                      color: Color.fromRGBO(44, 44, 44, 1),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
