import 'package:flutter/material.dart';
import 'package:shared_photo/components/feed_comp/feed/feed_list_item.dart';
import 'package:shared_photo/models/album.dart';

class FeedList extends StatelessWidget {
  final List<Album> feedAlbums;
  const FeedList({super.key, required this.feedAlbums});

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: feedAlbums.length,
      itemBuilder: (context, index) {
        return FeedListItem(
          key: ValueKey(feedAlbums[index].albumId),
          album: feedAlbums[index],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 20);
      },
    );
  }
}
