import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/new_album_comp/popular_comp/top_item_component.dart';
import 'package:shared_photo/models/album.dart';

class GuestsPage extends StatelessWidget {
  final Album album;
  const GuestsPage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.only(top: 12),
          ),
          SliverList.separated(
            itemCount: album.imagesGroupedByGuest.length,
            itemBuilder: (context, index) {
              int imagesToShow =
                  min(3, album.imagesGroupedByGuest[index].length);

              return Container(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                foregroundImage: CachedNetworkImageProvider(
                                  album
                                      .imagesGroupedByGuest[index][0].avatarReq,
                                  headers: headers,
                                ),
                                radius: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  album.imagesGroupedByGuest[index][0].fullName,
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
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: imagesToShow,
                        itemBuilder: (context, item) {
                          if (item == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TopItemComponent(
                                url: album
                                    .imagesGroupedByGuest[index][item].imageReq,
                                headers: headers,
                              ),
                            );
                          }
                          return TopItemComponent(
                            url: album
                                .imagesGroupedByGuest[index][item].imageReq,
                            headers: headers,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 10);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 25),
                child: Divider(
                  color: Color.fromRGBO(44, 44, 44, 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
