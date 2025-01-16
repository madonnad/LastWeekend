import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/album_comp/image_components/blank_item_component.dart';
import 'package:shared_photo/components/album_comp/image_components/top_item_component.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/models/album.dart';

class UnlockTimelinePage extends StatelessWidget {
  final Album album;
  const UnlockTimelinePage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Map<String, String> header = context.read<AppBloc>().state.user.headers;
    String userID = context.read<AppBloc>().state.user.id;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            sliver: SliverList.separated(
              itemCount: album.imagesGroupedSortedByDate.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: SectionHeaderSmall(
                          album.imagesGroupedSortedByDate[index][0].dateString),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: album.imagesGroupedSortedByDate[index].length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        //childAspectRatio: 4 / 5,
                      ),
                      itemBuilder: (context, item) {
                        if (album
                                .imagesGroupedSortedByDate[index][item].owner ==
                            userID) {
                          return SizedBox(
                            height: 100,
                            child: TopItemComponent(
                              image: album.imagesGroupedSortedByDate[index]
                                  [item],
                              headers: header,
                              showCount: false,
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: 100,
                            child: BlankItemComponent(
                              image: album.imagesGroupedSortedByDate[index]
                                  [item],
                              avatarUrl: album
                                  .imagesGroupedSortedByDate[index][item]
                                  .avatarReq,
                              headers: header,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
            ),
          ),
        ],
      ),
    );
  }
}
