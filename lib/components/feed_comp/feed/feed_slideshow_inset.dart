import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/feed_slideshow_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';

class FeedSlideshowInset extends StatelessWidget {
  final Album album;
  const FeedSlideshowInset({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedSlideshowCubit(
        album: album,
        dataRepository: context.read<DataRepository>(),
      ),
      child: BlocBuilder<FeedSlideshowCubit, FeedSlideshowState>(
        builder: (context, state) {
          Map<String, String> headers =
              context.read<AppBloc>().state.user.headers;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(44, 44, 44, .75),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      album.topThreeImages.isNotEmpty
                          ? PageView.builder(
                              onPageChanged: (index) => context
                                  .read<FeedSlideshowCubit>()
                                  .updatePage(index),
                              itemCount: album.topThreeImages.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        album.topThreeImages[index].imageReq540,
                                        headers: headers,
                                        errorListener: (_) {},
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    album.coverReq540,
                                    headers: headers,
                                    errorListener: (_) {},
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10.0,
                                  sigmaY: 10.0,
                                  tileMode: TileMode.clamp,
                                ),
                                child: Container(
                                  color: Colors.black45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(
                                      album.topThreeImages.length,
                                      (index) {
                                        return Text(
                                          (index + 1).toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: state.currentPage == index
                                                ? Colors.white
                                                : Colors.white24,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              backgroundImage: const AssetImage(
                                  "lib/assets/placeholder.png"),
                              foregroundImage: CachedNetworkImageProvider(
                                state.avatarUrl,
                                headers: headers,
                                errorListener: (_) {},
                              ),
                              onForegroundImageError: (_, __) {},
                              radius: 15,
                              backgroundColor:
                                  const Color.fromRGBO(44, 44, 44, .75),
                            ),
                          ),
                          Text(
                            state.imageOwnerName,
                            style: GoogleFonts.montserrat(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
