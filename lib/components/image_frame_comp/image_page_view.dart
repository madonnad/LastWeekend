import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/image_frame_comp/image_item.dart';

class ImagePageView extends StatelessWidget {
  final PageController mainController;
  final Map<String, String> headers;
  const ImagePageView(
      {super.key, required this.mainController, required this.headers});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
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
            String url = state.imageFrameTimelineList[index].imageReq1080;
            return ImageItem(
              url: url,
              headers: headers,
            );
          },
        );
      },
    );
  }
}
