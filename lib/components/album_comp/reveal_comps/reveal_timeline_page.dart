import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/image_components/top_item_component.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/models/photo.dart';

class RevealTimelinePage extends StatelessWidget {
  const RevealTimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> header = context.read<AppBloc>().state.user.headers;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
              builder: (context, state) {
                return SliverList.separated(
                  itemCount: state.imagesGroupedSortedByDate.length,
                  itemBuilder: (context, index) {
                    int rowCount =
                        (state.imagesGroupedSortedByDate[index].length / 3)
                            .ceil();
                    final double screenWidth =
                        MediaQuery.of(context).size.width - 30;
                    final double gridWidth = screenWidth / 3;
                    final double desiredRowHeight = 150;

                    String sectionString =
                        state.imagesGroupedSortedByDate[index][0].dateString;

                    if (state.imagesGroupedSortedByDate[index][0].type ==
                        UploadType.forgotShot) {
                      sectionString = "Forgot Shots 🫣";
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SectionHeaderSmall(sectionString),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 150 * rowCount.toDouble(),
                          ),
                          child: GridView.builder(
                            //shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                state.imagesGroupedSortedByDate[index].length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: gridWidth / desiredRowHeight,
                            ),
                            itemBuilder: (context, item) {
                              return SizedBox(
                                child: TopItemComponent(
                                  image: state.imagesGroupedSortedByDate[index]
                                      [item],
                                  headers: header,
                                  showCount: false,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 12);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
