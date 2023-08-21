import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc/feed_bloc.dart';

class CoverCard extends StatelessWidget {
  final int sliverIndex;
  const CoverCard({
    required this.sliverIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            state.albums[sliverIndex].albumCoverUrl ?? '',
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
