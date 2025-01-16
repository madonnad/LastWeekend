import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';

class NewMiniMap extends StatelessWidget {
  final PageController miniMapController;
  final Map<String, String> headers;
  const NewMiniMap(
      {super.key, required this.miniMapController, required this.headers});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        return PageView.builder(
          controller: miniMapController,
          itemCount: state.imageFrameTimelineList.length,
          padEnds: true,
          itemBuilder: (context, index) {
            String url = state.imageFrameTimelineList[index].imageReq1080;
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
                    child: Container(
                      //height: MediaQuery.of(context).size.height * .08,
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
                            errorListener: (_) =>
                                CachedNetworkImage.evictFromCache(url),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
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
