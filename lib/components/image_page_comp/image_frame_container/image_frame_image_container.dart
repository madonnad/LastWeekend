import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_comments/floating_comment_container.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_comments/image_frame_caption.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_comments/image_frame_comment.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/more_img_opts_dialog.dart';
import 'package:shared_photo/models/album.dart';
import 'dart:math' as math;

class ImageFrameImageContainer extends StatelessWidget {
  const ImageFrameImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        Map<String, String> headers =
            context.read<AppBloc>().state.user.headers;
        return Stack(
          children: [
            PageView.builder(
              controller: state.pageController,
              onPageChanged: (index) {
                context
                    .read<AlbumFrameCubit>()
                    .updateImageFrameWithSelectedImage(
                      index,
                      changeMiniMap: true,
                      changeMainPage: false,
                    );
              },
              itemCount: state.imageFrameTimelineList.length,
              itemBuilder: (context, index) {
                bool showImage = false;
                String userID = context.read<AppBloc>().state.user.id;
                showImage = state.album.phase == AlbumPhases.reveal ||
                    (state.imageFrameTimelineList[index].owner == userID);

                bool canSave = (state.album.phase != AlbumPhases.reveal &&
                        context.read<AppBloc>().state.user.id ==
                            state.selectedImage!.owner) ||
                    state.album.phase == AlbumPhases.reveal;

                if (showImage) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(19, 19, 19, 1),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                state.imageFrameTimelineList[index].imageReq,
                                headers: headers,
                              ),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      BlocBuilder<ImageFrameCubit, ImageFrameState>(
                        builder: (context, imageState) {
                          return Positioned(
                            bottom: 25,
                            left: 12,
                            child: Row(
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
                                    backgroundColor:
                                        const Color.fromRGBO(25, 25, 25, 1),
                                    foregroundImage: CachedNetworkImageProvider(
                                      imageState.image.avatarReq,
                                      headers: headers,
                                    ),
                                    radius: 17,
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  "${imageState.image.firstName} ${imageState.image.lastName}",
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
                            ),
                          );
                        },
                      ),
                      BlocBuilder<ImageFrameCubit, ImageFrameState>(
                        builder: (context, imageState) {
                          bool userLiked =
                              state.imageFrameTimelineList[index].userLiked;
                          bool userUpvoted =
                              state.imageFrameTimelineList[index].userUpvoted;
                          String numComments = state
                              .imageFrameTimelineList[index].comments.length
                              .toString();
                          return state.album.phase == AlbumPhases.reveal
                              ? Positioned(
                                  bottom: 16,
                                  right: 12,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6.0,
                                        ),
                                        child: Column(
                                          children: [
                                            Transform.rotate(
                                              angle: (270 * math.pi) / 180,
                                              child: GestureDetector(
                                                onTap: imageState.upvoteLoading
                                                    ? null
                                                    : () => context
                                                        .read<ImageFrameCubit>()
                                                        .toggleUpvote(),
                                                child: DecoratedIcon(
                                                  icon: userUpvoted
                                                      ? const Icon(
                                                          Icons.label_important,
                                                          size: 35,
                                                          color: Colors.white,
                                                          shadows: [
                                                            Shadow(
                                                              offset: Offset(
                                                                  0.0, 0.0),
                                                              blurRadius: 10.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ],
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .label_important_outline,
                                                          size: 35,
                                                          color: Colors.white,
                                                          shadows: [
                                                            Shadow(
                                                              offset: Offset(
                                                                  0.0, 0.0),
                                                              blurRadius: 15.0,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${state.imageFrameTimelineList[index].upvotes}",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                shadows: [
                                                  const Shadow(
                                                    offset: Offset(0.0, 0.0),
                                                    blurRadius: 10.0,
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6.0,
                                        ),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: imageState.likeLoading
                                                  ? null
                                                  : () => context
                                                      .read<ImageFrameCubit>()
                                                      .toggleLike(),
                                              child: DecoratedIcon(
                                                icon: userLiked
                                                    ? const Icon(
                                                        Icons.favorite,
                                                        color: Colors.white,
                                                        size: 35,
                                                        shadows: [
                                                          Shadow(
                                                            offset: Offset(
                                                                0.0, 0.0),
                                                            blurRadius: 10.0,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ],
                                                      )
                                                    : const Icon(
                                                        Icons.favorite_outline,
                                                        color: Colors.white,
                                                        size: 35,
                                                        shadows: [
                                                          Shadow(
                                                            offset: Offset(
                                                                0.0, 0.0),
                                                            blurRadius: 10.0,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ),
                                            Text(
                                              "${state.imageFrameTimelineList[index].likes}",
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                shadows: [
                                                  const Shadow(
                                                    offset: Offset(0.0, 0.0),
                                                    blurRadius: 10.0,
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6.0,
                                        ),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () => showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (ctx) =>
                                                    MultiBlocProvider(
                                                  providers: [
                                                    BlocProvider.value(
                                                      value: context.read<
                                                          AlbumFrameCubit>(),
                                                    ),
                                                    BlocProvider.value(
                                                      value: context.read<
                                                          ImageFrameCubit>(),
                                                    ),
                                                  ],
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                      8,
                                                      20,
                                                      8,
                                                      MediaQuery.of(context)
                                                          .viewInsets
                                                          .bottom,
                                                    ),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .75,
                                                    child: BlocBuilder<
                                                        AlbumFrameCubit,
                                                        AlbumFrameState>(
                                                      builder:
                                                          (context, state) {
                                                        return Column(
                                                          children: [
                                                            ImageFrameCaption(
                                                              headers: headers,
                                                              selectedImage: state
                                                                  .selectedImage,
                                                              phase: state
                                                                  .album.phase,
                                                            ),
                                                            BlocBuilder<
                                                                ImageFrameCubit,
                                                                ImageFrameState>(
                                                              builder: (context,
                                                                  state) {
                                                                return Expanded(
                                                                  child: ListView
                                                                      .builder(
                                                                    itemCount: state
                                                                        .comments
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            item) {
                                                                      return ImageFrameComment(
                                                                        headers:
                                                                            headers,
                                                                        comment:
                                                                            state.comments[item],
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                            FloatingCommentContainer(
                                                                headers:
                                                                    headers),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              child: const DecoratedIcon(
                                                icon: Icon(
                                                  Icons.comment,
                                                  color: Colors.white,
                                                  size: 35,
                                                  shadows: [
                                                    const Shadow(
                                                      offset: Offset(0.0, 0.0),
                                                      blurRadius: 10.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              numComments,
                                              style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                shadows: [
                                                  const Shadow(
                                                    offset: Offset(0.0, 0.0),
                                                    blurRadius: 10.0,
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 6.0,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) {
                                                      return MultiBlocProvider(
                                                        providers: [
                                                          BlocProvider.value(
                                                            value: context.read<
                                                                AlbumFrameCubit>(),
                                                          ),
                                                          BlocProvider.value(
                                                            value: context.read<
                                                                ImageFrameCubit>(),
                                                          ),
                                                        ],
                                                        child:
                                                            MoreImageOptsDialog(
                                                          canSave: canSave,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Transform.rotate(
                                                  angle: (270 * math.pi) / 180,
                                                  child: const DecoratedIcon(
                                                    icon: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.white,
                                                      size: 35,
                                                      shadows: [
                                                        Shadow(
                                                          offset:
                                                              Offset(0.0, 0.0),
                                                          blurRadius: 10.0,
                                                          color: Colors.black54,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Positioned(
                                  bottom: 16,
                                  right: 12,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return MultiBlocProvider(
                                              providers: [
                                                BlocProvider.value(
                                                  value: context
                                                      .read<AlbumFrameCubit>(),
                                                ),
                                                BlocProvider.value(
                                                  value: context
                                                      .read<ImageFrameCubit>(),
                                                ),
                                              ],
                                              child: MoreImageOptsDialog(
                                                canSave: canSave,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Transform.rotate(
                                        angle: (270 * math.pi) / 180,
                                        child: const DecoratedIcon(
                                          icon: Icon(
                                            Icons.more_horiz,
                                            color: Colors.white,
                                            size: 35,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(0.0, 0.0),
                                                blurRadius: 10.0,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(44, 44, 44, .75),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "🫣",
                          style: TextStyle(fontSize: 55),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: DecoratedIcon(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                  decoration: IconDecoration(
                    border: IconBorder(width: 0.75),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
