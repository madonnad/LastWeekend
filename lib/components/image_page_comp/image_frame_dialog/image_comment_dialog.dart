import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_engagement/floating_comment_container.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_engagement/image_frame_caption.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_engagement/image_frame_comment.dart';

class ImageCommentDialog extends StatelessWidget {
  const ImageCommentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        8,
        20,
        8,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      height: MediaQuery.of(context).size.height * .75,
      child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
        builder: (context, state) {
          Map<String, String> headers =
              context.read<AppBloc>().state.user.headers;
          return Column(
            children: [
              ImageFrameCaption(
                headers: headers,
                selectedImage: state.selectedImage,
                phase: state.album.phase,
              ),
              BlocBuilder<ImageFrameCubit, ImageFrameState>(
                builder: (context, state) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.comments.length,
                      itemBuilder: (context, item) {
                        return ImageFrameComment(
                          headers: headers,
                          comment: state.comments[item],
                        );
                      },
                    ),
                  );
                },
              ),
              FloatingCommentContainer(headers: headers),
            ],
          );
        },
      ),
    );
  }
}
