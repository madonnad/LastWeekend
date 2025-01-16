import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/empty_album_unlock.dart';
import 'package:shared_photo/components/album_comp/image_components/top_item_component.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/event_guest_row.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/trending_slideshow.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';

class RevealEventLanding extends StatelessWidget {
  const RevealEventLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        Map<String, String> header = context.read<AppBloc>().state.user.headers;

        return state.images.isNotEmpty
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: Gap(6)),
                      SliverToBoxAdapter(
                        child: TrendingSlideshow(
                          slideshowPhotos: state.popularPhotoSlider,
                          albumID: state.album.albumId,
                        ),
                      ),
                      SliverToBoxAdapter(child: Gap(15)),
                      SliverToBoxAdapter(
                          child: EventGuestRow(
                              guestList: state.mostImagesUploaded)),
                      SliverToBoxAdapter(child: Gap(15)),

                      // SliverGrid(
                      //   delegate: SliverChildBuilderDelegate(
                      //     (BuildContext context, int index) {
                      //       return TopItemComponent(
                      //         image: state.rankedImages[index],
                      //         showCount: false,
                      //         headers:
                      //             context.read<AppBloc>().state.user.headers,
                      //       );
                      //     },
                      //     childCount: state.rankedImages.length,
                      //   ),
                      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 3, // Number of columns
                      //     crossAxisSpacing: 4,
                      //     mainAxisSpacing: 4,
                      //   ),
                      // ),
                      SliverList.separated(
                        itemCount: state.imagesGroupedSortedByDate.length,
                        itemBuilder: (context, index) {
                          if (state
                              .imagesGroupedSortedByDate[index].isNotEmpty) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: SectionHeaderSmall(state
                                      .imagesGroupedSortedByDate[index][0]
                                      .dateString),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state
                                      .imagesGroupedSortedByDate[index].length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    //childAspectRatio: 4 / 5,
                                  ),
                                  itemBuilder: (context, item) {
                                    return TopItemComponent(
                                      image:
                                          state.imagesGroupedSortedByDate[index]
                                              [item],
                                      headers: header,
                                      showCount: false,
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                        // physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 0);
                        },
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: Center(
                  child: EmptyAlbumView(
                    isUnlockPhase: false,
                    album: state.album,
                  ),
                ),
              );
      },
    );
  }
}
