import 'package:flutter/material.dart';
import 'package:shared_photo/components/feed_comp/dashboard/create_album_component.dart';
import 'package:shared_photo/components/feed_comp/dashboard/list_album_component.dart';
import 'package:shared_photo/models/album.dart';

class HorizontalAlbumList extends StatelessWidget {
  final List<Album> albumList;
  final bool showCreateAlbum;
  const HorizontalAlbumList(
      {super.key, required this.albumList, required this.showCreateAlbum});

  @override
  Widget build(BuildContext context) {
    int count = showCreateAlbum ? albumList.length + 1 : albumList.length;

    return Expanded(
      child: ListView.separated(
        itemCount: count,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (showCreateAlbum) {
            if (index == albumList.length) {
              return const CreateAlbumComponent();
            } else {
              return ListAlbumComponent(
                album: albumList[index],
              );
            }
          } else {
            return ListAlbumComponent(
              album: albumList[index],
            );
          }
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
