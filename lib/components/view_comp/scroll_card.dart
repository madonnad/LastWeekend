import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

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
        String token = context.read<AppBloc>().state.user.token;
        Map<String, String> headers = {"Authorization": "Bearer $token"};

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12.5,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: (state.loading == false)
              ? Image.network(
                  state.albums[sliverIndex].images[index].imageReq,
                  headers: headers,
                  fit: BoxFit.cover,
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                ),
        );
      },
    );
  }
}
