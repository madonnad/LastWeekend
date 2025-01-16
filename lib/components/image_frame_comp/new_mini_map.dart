import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/image_frame_comp/hidden_image.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/photo.dart';

class NewMiniMap extends StatelessWidget {
  final PageController miniMapController;
  final Map<String, String> headers;
  const NewMiniMap(
      {super.key, required this.miniMapController, required this.headers});

  @override
  Widget build(BuildContext context) {
    String userID = context.read<AppBloc>().state.user.id;

    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        bool isReveal = state.album.phase == AlbumPhases.reveal;

        return PageView.builder(
          controller: miniMapController,
          itemCount: state.imageFrameTimelineList.length,
          padEnds: true,
          itemBuilder: (context, index) {
            Photo photo = state.imageFrameTimelineList[index];
            String url = photo.imageReq540;
            bool isImageOwner = photo.owner == userID;

            return AnimatedBuilder(
              animation: miniMapController,
              builder: (context, child) {
                double page = miniMapController.page ?? 0.0;
                double distance = (page - index).abs();

                // Determine the scale factor
                double scale = 1.0 - (distance * 0.25).clamp(0.0, 0.25);

                return GestureDetector(
                  onTap: () => miniMapController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  ),
                  child: Transform.scale(
                    scale: scale,
                    child: Builder(
                      builder: (context) {
                        if (isReveal) {
                          return MiniMapImage(url: url, headers: headers);
                        } else if (!isReveal && isImageOwner) {
                          return MiniMapImage(url: url, headers: headers);
                        } else {
                          return HiddenImage(
                            fontSize: 16,
                            borderRadius: 5,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class MiniMapImage extends StatelessWidget {
  final String url;
  final Map<String, String> headers;
  const MiniMapImage({super.key, required this.url, required this.headers});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(19, 19, 19, 1),
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            url,
            headers: headers,
            errorListener: (_) => CachedNetworkImage.evictFromCache(url),
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
