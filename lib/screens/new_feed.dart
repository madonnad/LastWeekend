import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/dashboard_bloc.dart';
import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/components/feed_comp/dashboard/dashboard.dart';
import 'package:shared_photo/components/feed_comp/feed/empty_feed.dart';
import 'package:shared_photo/components/feed_comp/feed/feed_list.dart';

class NewFeed extends StatefulWidget {
  final double devHeight;
  const NewFeed({super.key, required this.devHeight});

  @override
  State<NewFeed> createState() => _NewFeedState();
}

class _NewFeedState extends State<NewFeed> {
  final ScrollController _scrollController = ScrollController();
  bool _collapsed = false;
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      if (_scrollController.hasClients &&
          _scrollController.offset > (widget.devHeight * (.75))) {
        _collapsed = true;
        _changeOpacity();
      }
      if (_scrollController.offset < (widget.devHeight * (.75))) {
        _collapsed = false;
        _changeOpacity();
      }
    });
  }

  void _changeOpacity() {
    setState(() {
      opacityLevel = _collapsed ? 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double devHeight = MediaQuery.of(context).size.height;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          expandedHeight: devHeight * .75,
          title: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: opacityLevel,
            child: GestureDetector(
              onTap: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              ),
              child: const Center(
                child: StandardLogo(fontSize: 30),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1,
            collapseMode: CollapseMode.pin,
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
              child: const SafeArea(
                child: Dashboard(),
              ),
            ),
          ),
        ),
        BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state.revealedFeedAlbumList.isNotEmpty) {
              return const FeedList();
            } else {
              return const EmptyFeed();
            }
          },
        )
      ],
    );
  }
}
