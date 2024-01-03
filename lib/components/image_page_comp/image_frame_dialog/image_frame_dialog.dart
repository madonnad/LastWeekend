import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/new_album_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_appbar.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/dialog_image_row.dart';

class ImageFrameDialog extends StatelessWidget {
  const ImageFrameDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageFrameCubit, ImageFrameState>(
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
                    itemCount: state.selectedModeImages.length,
                    itemBuilder: (context, index) {
                      String listText = '';
                      switch (state.viewMode) {
                        case AlbumViewMode.popular:
                          listText =
                              "${state.selectedModeImages[index].upvotes} Upvotes";
                        // if (index != 0) {
                        //   String previousText =
                        //       "${state.selectedModeImages[index - 1].upvotes} Upvotes";
                        //   if (listText == previousText) {
                        //     listText = '';
                        //   }
                        // }
                        case AlbumViewMode.guests:
                          listText = state.selectedModeImages[index].fullName;
                        // if (index != 0) {
                        //   String previousText =
                        //       state.selectedModeImages[index - 1].fullName;
                        //   if (listText == previousText) {
                        //     listText = '';
                        //   }
                        // }
                        case AlbumViewMode.timeline:
                          listText = state.selectedModeImages[index].dateString;
                        // if (index != 0) {
                        //   String previousText =
                        //       state.selectedModeImages[index - 1].dateString;
                        //   if (listText == previousText) {
                        //     listText = '';
                        //   }
                        // }
                      }

                      return GestureDetector(
                        onTap: () {
                          context.read<ImageFrameCubit>().imageChange(index);
                          state.pageController.jumpToPage(index);
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 140,
                            child: DialogImageRow(
                              url: state.selectedModeImages[index].imageReq,
                              headers: headers,
                              listText: listText,
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
