import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/album_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/album_comp/image_comps/blank_timeline_image.dart';
import 'package:shared_photo/components/album_comp/image_comps/timeline_separator.dart';
import 'package:shared_photo/components/album_comp/image_comps/visible_timeline_image.dart';

class LockTimelineTab extends StatelessWidget {
  const LockTimelineTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        Map<String, String> header = context.read<AppBloc>().state.user.headers;
        final String uid = context.read<AppBloc>().state.user.id;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: TimelineSeparator(
                dateString: state.album.images[0].dateString,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: ListView.separated(
                  itemCount: state.album.images.length,
                  separatorBuilder: (context, index) {
                    if (index != 0) {
                      if (state.album.images[index].uploadDateTime.day >
                          state.album.images[index - 1].uploadDateTime.day) {
                        return TimelineSeparator(
                          dateString: state.album.images[index].dateString,
                        );
                      }
                    }
                    return const SizedBox(
                      width: 0,
                    );
                  },
                  itemBuilder: (context, index) {
                    return state.album.images[index].owner == uid
                        ? InkWell(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  surfaceTintColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  child: Card(
                                    clipBehavior: Clip.hardEdge,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          state.album.images[index].imageReq,
                                      httpHeaders: header,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            ),
                            child: VisibleTimelineImage(
                                index: index, header: header),
                          )
                        : BlankTimelineImage(index: index, header: header);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
