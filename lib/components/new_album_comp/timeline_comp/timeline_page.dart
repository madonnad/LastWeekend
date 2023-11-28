import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/new_album_comp/popular_comp/top_item_component.dart';
import 'package:shared_photo/models/album.dart';

class TimelinePage extends StatelessWidget {
  final Album album;
  const TimelinePage({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Map<String, String> header = context.read<AppBloc>().state.user.headers;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (context, item) {
                        return TopItemComponent(
                          url: album
                              .imagesGroupedSortedByDate[index][item].imageReq,
                          headers: header,
                        );
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
