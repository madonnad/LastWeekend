import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/image_frame_comp/hidden_image.dart';
import 'package:shared_photo/components/image_frame_comp/image_item.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/photo.dart';

class ImagePageView extends StatelessWidget {
  final PageController mainController;
  final Map<String, String> headers;
  const ImagePageView(
      {super.key, required this.mainController, required this.headers});

  @override
  Widget build(BuildContext context) {
    String userID = context.read<AppBloc>().state.user.id;
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        bool isReveal = state.album.phase == AlbumPhases.reveal;
        return PageView.builder(
          controller: mainController,
          itemCount: state.imageFrameTimelineList.length,
          onPageChanged: (index) {
            context.read<AlbumFrameCubit>().updateImageFrameWithSelectedImage(
                  index,
                  changeMiniMap: true,
                  changeMainPage: false,
                );
          },
          itemBuilder: (context, index) {
            Photo photo = state.imageFrameTimelineList[index];
            String url = photo.imageReq1080;
            bool isImageOwner = photo.owner == userID;

            if (isReveal) {
              return ImageItem(
                url: url,
                headers: headers,
              );
            } else if (!isReveal && isImageOwner) {
              return ImageItem(
                url: url,
                headers: headers,
              );
            } else {
              return HiddenImage(
                fontSize: 32,
                borderRadius: 0,
              );
            }
          },
        );
      },
    );
  }
}
