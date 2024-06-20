import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/image_frame_dialog.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/more_img_opts_dialog.dart';
import 'package:shared_photo/models/album.dart';

class ImageFrameControlBar extends StatelessWidget {
  const ImageFrameControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        int pageNumber = state.imageFrameTimelineList
            .indexWhere((element) => element == state.selectedImage);

        bool canSave = (state.album.phase != AlbumPhases.reveal &&
                context.read<AppBloc>().state.user.id ==
                    state.selectedImage!.owner) ||
            state.album.phase == AlbumPhases.reveal;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.space_bar,
                color: Colors.transparent,
              ),
              const Spacer(),
              pageNumber != 0
                  ? GestureDetector(
                      onTap: () =>
                          context.read<AlbumFrameCubit>().previousImage(),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 25,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.abc,
                      size: 25,
                      color: Colors.transparent,
                    ),
              const SizedBox(width: 25),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  barrierColor: Colors.black87,
                  builder: (ctx) => BlocProvider.value(
                    value: BlocProvider.of<AlbumFrameCubit>(context),
                    child: const ImageFrameDialog(),
                  ),
                ),
                child: const Icon(
                  Icons.view_timeline,
                  size: 25,
                  color: Color.fromRGBO(225, 225, 225, 1),
                ),
              ),
              const SizedBox(width: 25),
              pageNumber != state.imageFrameTimelineList.length - 1
                  ? GestureDetector(
                      onTap: () => context.read<AlbumFrameCubit>().nextImage(),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 25,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.abc,
                      size: 25,
                      color: Colors.transparent,
                    ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return BlocProvider.value(
                          value: context.read<ImageFrameCubit>(),
                          child: MoreImageOptsDialog(
                            canSave: canSave,
                          ));
                    },
                  );
                },
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
