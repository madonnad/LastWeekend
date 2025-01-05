import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/image_frame_dialog.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_minimap/mini_hidden_image.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_minimap/mini_map_image.dart';
import 'package:shared_photo/models/album.dart';

class ImageMiniMap extends StatelessWidget {
  const ImageMiniMap({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * .08,
          margin: const EdgeInsets.only(top: 15, bottom: 15),
          color: Colors.transparent,
          child: Stack(
            children: [
              PageView.builder(
                controller: state.miniMapController,
                itemCount: state.imageFrameTimelineList.length,
                itemBuilder: (context, index) {
                  bool isImage = state.selectedImage?.imageId ==
                      state.imageFrameTimelineList[index].imageId;
                  bool showImage = false;
                  String userID = context.read<AppBloc>().state.user.id;
                  showImage = state.album.phase == AlbumPhases.reveal ||
                      (state.imageFrameTimelineList[index].owner == userID);
                  return GestureDetector(
                      onTap: () {
                        context
                            .read<AlbumFrameCubit>()
                            .updateImageFrameWithSelectedImage(
                              index,
                              changeMiniMap: true,
                              changeMainPage: true,
                            );
                      },
                      child: showImage
                          ? MiniMapImage(
                              isImage: isImage,
                              imageReq: state
                                  .imageFrameTimelineList[index].imageReq540,
                            )
                          : MiniHiddenImage(isImage: isImage));
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: MediaQuery.of(context).size.height * .08,
                  padding: const EdgeInsets.only(left: 8),
                  color: Colors.black,
                  child: GestureDetector(
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
                      size: 30,
                      color: Color.fromRGBO(225, 225, 225, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
