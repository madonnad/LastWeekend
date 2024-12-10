import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_appbar.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/dialog_image_row.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/photo.dart';

class ImageFrameDialog extends StatelessWidget {
  const ImageFrameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        Map<String, String> headers =
            context.read<AppBloc>().state.user.headers;
        return Dialog(
          insetPadding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 10,
            right: 10,
          ),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                const ImageFrameAppBar(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.imageFrameTimelineList.length,
                    itemBuilder: (context, index) {
                      String listText = '';

                      listText =
                          "${state.imageFrameTimelineList[index].dateString} ${state.imageFrameTimelineList[index].timeString}";

                      if (state.imageFrameTimelineList[index].type ==
                          UploadType.forgotShot) {
                        listText = "Forgot Shot 🫣";
                      }

                      String userID = context.read<AppBloc>().state.user.id;

                      bool showImage = false;
                      Photo image = state.imageFrameTimelineList[index];

                      showImage = state.album.phase == AlbumPhases.reveal ||
                          image.owner == userID;

                      return GestureDetector(
                        onTap: () {
                          context
                              .read<AlbumFrameCubit>()
                              .updateImageFrameWithSelectedImage(index,
                                  changeMiniMap: false, changeMainPage: true);

                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 140,
                            child: DialogImageRow(
                              url: state.imageFrameTimelineList[index].imageReq,
                              headers: headers,
                              listText: listText,
                              showImage: showImage,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
