import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_container/image_owner_row.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_engagement/engagement_column.dart';

import 'package:shared_photo/models/album.dart';

class ImageFrameImageContainer extends StatefulWidget {
  const ImageFrameImageContainer({super.key});

  @override
  State<ImageFrameImageContainer> createState() =>
      _ImageFrameImageContainerState();
}

class _ImageFrameImageContainerState extends State<ImageFrameImageContainer> {
  bool canScroll = true;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        Map<String, String> headers =
            context.read<AppBloc>().state.user.headers;

        String userID = context.read<AppBloc>().state.user.id;
        bool isInEvent = state.album.guestMap.containsKey(userID);

        return Stack(
          children: [
            PageView.builder(
              controller: state.pageController,
              physics: canScroll
                  ? BouncingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
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
                String userID = context.read<AppBloc>().state.user.id;

                bool showImage = state.album.phase == AlbumPhases.reveal ||
                    (state.imageFrameTimelineList[index].owner == userID);

                bool canSave = (state.album.phase != AlbumPhases.reveal &&
                        context.read<AppBloc>().state.user.id ==
                            state.selectedImage!.owner) ||
                    state.album.phase == AlbumPhases.reveal;

                bool isReveal = state.album.phase == AlbumPhases.reveal;

                if (showImage) {
                  return BlocBuilder<ImageFrameCubit, ImageFrameState>(
                    builder: (context, imageState) {
                      return Stack(
                        children: [
                          PinchZoomReleaseUnzoomWidget(
                            twoFingersOn: () => setState(() {
                              canScroll = false;
                            }),
                            twoFingersOff: () => setState(() {
                              canScroll = true;
                            }),
                            resetDuration: Duration(milliseconds: 300),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(19, 19, 19, 1),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    state.imageFrameTimelineList[index]
                                        .imageReq1080,
                                    headers: headers,
                                    errorListener: (_) =>
                                        CachedNetworkImage.evictFromCache(state
                                            .imageFrameTimelineList[index]
                                            .imageReq),
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            left: 12,
                            child: ImageOwnerRow(
                              fullName:
                                  "${imageState.image.firstName} ${imageState.image.lastName}",
                              imageAvatarUrl: imageState.image.avatarReq540,
                              headers: headers,
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 12,
                            child: EngagementColumn(
                              isInEvent: isInEvent,
                              isReveal: isReveal,
                              canSave: canSave,
                            ),
                          ),
                        ],
                      );
                    },
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
