import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/components/feed_comp/feed/feed_list_item.dart';
import 'package:shared_photo/models/album.dart';

class FeedList extends StatelessWidget {
  const FeedList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return SliverList.separated(
          itemCount: state.feedAlbumList.length,
          itemBuilder: (context, index) {
            if (state.feedAlbumList[index].phase == AlbumPhases.reveal &&
                index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: FeedListItem(
                  album: state.feedAlbumList[index],
                ),
              );
            }
            if (state.feedAlbumList[index].phase == AlbumPhases.reveal) {
              return FeedListItem(
                album: state.feedAlbumList[index],
              );
            } else {
              return null;
            }
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 20);
          },
        );
      },
    );
  }
}
