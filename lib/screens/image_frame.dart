import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_comments/floating_comment_container.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_comments/image_frame_caption.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_comments/image_frame_comment.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_container/image_frame_image_container.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_control_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_appbar.dart';

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
          Map<String, String> headers =
              context.read<AppBloc>().state.user.headers;
          return Stack(
            children: [
              SizedBox(
                height: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(child: ImageFrameAppBar()),
                      const SliverToBoxAdapter(
                        child: ImageFrameImageContainer(),
                      ),
                      const SliverToBoxAdapter(
                        child: ImageFrameControlBar(),
                      ),
                      SliverToBoxAdapter(
                        child: ImageFrameCaption(headers: headers),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, item) {
                            return ImageFrameComment(
                              headers: headers,
                              comment: state.comments[item],
                            );
                          },
                          childCount: state.comments.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).padding.bottom + 100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).padding.bottom,
                child: FloatingCommentContainer(
                  headers: headers,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
