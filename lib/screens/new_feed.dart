import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/components/feed_comp/feed/empty_feed.dart';
import 'package:shared_photo/components/feed_comp/feed/feed_list.dart';
import 'package:shared_photo/components/feed_comp/header/events_header.dart';

class NewFeed extends StatefulWidget {
  final double devHeight;
  const NewFeed({super.key, required this.devHeight});

  @override
  State<NewFeed> createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<AppFrameCubit, AppFrameState>(
      builder: (context, state) {
        return SafeArea(
          child: CustomScrollView(
            controller: state.feedScrollController,
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Color.fromRGBO(19, 19, 20, 1),
                surfaceTintColor: Colors.transparent,
                // title: Center(
                //   child: StandardLogo(fontSize: 30),
                // ),
                title: GestureDetector(
                  child: Image.asset("lib/assets/logo.png", height: 40),
                  onTap: () => context.read<AppFrameCubit>().jumpToTopOfFeed(),
                ),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: EventsHeader(),
              ),
              BlocBuilder<FeedBloc, FeedState>(
                builder: (context, state) {
                  if (state.revealedFeedAlbumList.isNotEmpty) {
                    return FeedList(
                      feedAlbums: state.revealedFeedAlbumList,
                    );
                  } else {
                    return const EmptyFeed();
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
