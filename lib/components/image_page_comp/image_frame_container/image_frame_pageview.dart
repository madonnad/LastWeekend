import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_container/image_frame_hidden_image.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_container/image_frame_image.dart';
import 'package:shared_photo/models/album.dart';

class ImageFramePageView extends StatefulWidget {
  const ImageFramePageView({super.key});

  @override
  State<ImageFramePageView> createState() => _ImageFramePageViewState();
}

class _ImageFramePageViewState extends State<ImageFramePageView> {
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
                      return ImageFrameImage(
                        url: state.imageFrameTimelineList[index].imageReq1080,
                        headers: headers,
                        firstName: imageState.image.firstName,
                        lastName: imageState.image.lastName,
                        userUrl: imageState.image.avatarReq540,
                        isInEvent: isInEvent,
                        isReveal: isReveal,
                        canSave: canSave,
                      );
                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ImageFrameHiddenImage(),
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
