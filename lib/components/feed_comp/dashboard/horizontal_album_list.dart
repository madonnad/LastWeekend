import 'package:flutter/material.dart';
import 'package:shared_photo/components/feed_comp/dashboard/list_album_component.dart';
import 'package:shared_photo/models/album.dart';

class HorizontalAlbumList extends StatelessWidget {
  final List<Album> albumList;
  const HorizontalAlbumList({super.key, required this.albumList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: albumList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return ListAlbumComponent(
            album: albumList[index],
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 10,
          );
        },
      ),
    );
  }
}
