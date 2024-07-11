import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/empty_album_unlock.dart';
import 'package:shared_photo/components/album_comp/image_components/first_item_component.dart';
import 'package:shared_photo/components/album_comp/image_components/top_item_component.dart';

class PopularPage extends StatelessWidget {
  const PopularPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;

    return SafeArea(
      child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
        builder: (context, state) {
          return state.topThreeImages.isNotEmpty
              ? CustomScrollView(
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 12, left: 15),
                    ),
                    BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                      builder: (context, state) {
                        return SliverToBoxAdapter(
                            child: FirstItemComponent(
                          image: state.topThreeImages[0],
                          headers: headers,
                        ));
                      },
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 8),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      sliver: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                        builder: (context, state) {
                          return SliverGrid.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 4 / 5,
                            ),
                            itemCount: state.topThreeImages.isEmpty
                                ? 0
                                : state.topThreeImages.length - 1,
                            itemBuilder: (context, index) {
                              return TopItemComponent(
                                image: state.topThreeImages[index + 1],
                                headers: headers,
                                showCount: true,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 8),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      sliver: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                        builder: (context, state) {
                          return SliverGrid.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 4 / 5,
                            ),
                            itemCount: state.remainingRankedImages.length,
                            itemBuilder: (context, index) {
                              return TopItemComponent(
                                image: state.remainingRankedImages[index],
                                headers: headers,
                                showCount: true,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
              : EmptyAlbumView(
                  isUnlockPhase: false,
                  album: state.album,
                );
        },
      ),
    );
  }
}
