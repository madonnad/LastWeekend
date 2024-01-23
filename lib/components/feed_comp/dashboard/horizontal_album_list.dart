import 'package:flutter/material.dart';
import 'package:shared_photo/components/feed_comp/dashboard/create_album_component.dart';
import 'package:shared_photo/components/feed_comp/dashboard/list_album_component.dart';
import 'package:shared_photo/models/album.dart';

class HorizontalAlbumList extends StatelessWidget {
  final List<Album> albumList;
  const HorizontalAlbumList({super.key, required this.albumList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: albumList.length + 1,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const CreateAlbumComponent();
          }
          return ListAlbumComponent(
            album: albumList[index - 1],
            index: index - 1,
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
