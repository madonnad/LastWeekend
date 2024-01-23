import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/feed_comp/dashboard/horizontal_album_list.dart';

class AlbumHorizontalListView extends StatelessWidget {
  const AlbumHorizontalListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 25.0, bottom: 5),
              child: SectionHeaderSmall("active albums"),
            ),
            HorizontalAlbumList(
              albumList: state.activeAlbums,
            ),
          ],
        );
      },
    );
  }
}
