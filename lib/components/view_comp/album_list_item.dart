// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_photo/bloc/bloc/feed_bloc.dart';
import 'package:shared_photo/components/view_comp/carousel_view.dart';

class AlbumListItem extends StatelessWidget {
  final int position;
  final PageController instanceController;
  const AlbumListItem({
    Key? key,
    required this.position,
    required this.instanceController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 75.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.albums[position].albumName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          state.albums[position].albumOwner,
                          style: const TextStyle(fontWeight: FontWeight.w200),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: deviceHeight * .55,
                child: PageView.builder(
                  allowImplicitScrolling: true,
                  scrollDirection: Axis.horizontal,
                  controller: instanceController,
                  physics: const ClampingScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, count) {
                    return CarouselView(
                      sliverIndex: position,
                      index: count,
                      pageController: instanceController,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
