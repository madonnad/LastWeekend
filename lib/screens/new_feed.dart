import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/bloc/cubit/feed_slideshow_cubit.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/components/feed_comp/dashboard/dashboard.dart';
import 'package:shared_photo/components/feed_comp/feed/feed_list_item.dart';
import 'package:shared_photo/components/feed_comp/feed/feed_slideshow_inset.dart';
import 'package:shared_photo/models/album.dart';

class NewFeed extends StatelessWidget {
  const NewFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final double devHeight = MediaQuery.of(context).size.height;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.black,
          expandedHeight: devHeight * .75,
          title: const StandardLogo(),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.none,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(19, 19, 19, 1),
                    Color.fromRGBO(19, 19, 19, 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, (devHeight * .16), 15, 30),
                child: const Dashboard(),
              ),
            ),
          ),
        ),
        BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            return SliverList.separated(
              itemCount: state.albums.length,
              itemBuilder: (context, index) {
                if (state.albums[index].phase == AlbumPhases.reveal) {
                  return FeedListItem(
                    album: state.albums[index],
                  );
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 35);
              },
            );
          },
        ),
      ],
    );
  }
}
