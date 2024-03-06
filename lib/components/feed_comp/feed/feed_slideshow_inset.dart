import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/feed_slideshow_cubit.dart';
import 'package:shared_photo/models/arguments.dart';

class FeedSlideshowInset extends StatelessWidget {
  const FeedSlideshowInset({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedSlideshowCubit, FeedSlideshowState>(
      builder: (context, state) {
        Map<String, String> headers =
            context.read<AppBloc>().state.user.headers;
        Arguments arguments = Arguments(album: state.album);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/album', arguments: arguments);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(44, 44, 44, .75),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      PageView.builder(
                        onPageChanged: (index) => context
                            .read<FeedSlideshowCubit>()
                            .updatePage(index),
                        controller: state.pageController,
                        itemCount: state.topThreeImages.length,
                        allowImplicitScrolling: true,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  state.topThreeImages[index].imageReq,
                                  headers: headers,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
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
                                      3,
                                      (index) {
                                        return Text(
                                          (index + 1).toString(),
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: state.currentPage == index
                                                ? Colors.white
                                                : Colors.white
                                                    .withOpacity(0.25),
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
                            backgroundImage: CachedNetworkImageProvider(
                              state.avatarUrl,
                              headers: headers,
                            ),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(
                          Icons.comment_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      Icon(
                        Icons.favorite_outline,
                        color: Colors.white54,
                        size: 25,
                      ),
                      // Icon(
                      //   Icons.arrow_circle_up,
                      //   color: Colors.white54,
                      //   size: 25,
                      // ),
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
