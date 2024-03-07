import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/image_components/top_item_component.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';

class PopularPage extends StatelessWidget {
  const PopularPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 15),
            sliver: SliverToBoxAdapter(
              child: SectionHeaderSmall("Top Photos"),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                builder: (context, state) {
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.topThreeImages.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TopItemComponent(
                            image: state.topThreeImages[index],
                            radius: 18,
                            headers: headers,
                          ),
                        );
                      }
                      if (index < 3) {
                        return Stack(
                          children: [
                            TopItemComponent(
                              image: state.topThreeImages[index],
                              radius: 18,
                              headers: headers,
                            ),
                          ],
                        );
                      } else {
                        return null;
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 8,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            sliver: SliverToBoxAdapter(
              child: Divider(
                color: Color.fromRGBO(44, 44, 44, 1),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            sliver: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
              builder: (context, state) {
                return SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 4 / 5,
                  ),
                  itemCount: state.remainingRankedImages.length,
                  itemBuilder: (context, index) {
                    return TopItemComponent(
                      image: state.remainingRankedImages[index],
                      radius: 14,
                      headers: headers,
                    );
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
