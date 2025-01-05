import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';

import 'package:shared_photo/components/image_page_comp/image_frame_container/image_frame_pageview.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_minimap/image_mini_map.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlbumFrameCubit, AlbumFrameState>(
      listenWhen: (previous, current) {
        return previous.selectedImage != current.selectedImage;
      },
      listener: (context, state) {
        context
            .read<ImageFrameCubit>()
            .changeImageFrameState(state.selectedImage!);
      },
      child: BlocBuilder<ImageFrameCubit, ImageFrameState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                const Expanded(
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: ImageFramePageView(),
                  ),
                ),
                ImageMiniMap(),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
