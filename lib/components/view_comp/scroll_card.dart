import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc/feed_bloc.dart';

class ScrollCard extends StatelessWidget {
  final int sliverIndex;
  final int index;
  const ScrollCard({
    required this.sliverIndex,
    required this.index,
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
            state.albums[sliverIndex].images[index].imageId,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}
