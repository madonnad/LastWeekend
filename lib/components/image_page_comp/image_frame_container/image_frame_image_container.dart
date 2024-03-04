import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_container/image_frame_metadata_row.dart';

class ImageFrameImageContainer extends StatelessWidget {
  const ImageFrameImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        Map<String, String> headers =
            context.read<AppBloc>().state.user.headers;
        return Container(
          height: MediaQuery.of(context).size.height * .6,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color.fromRGBO(19, 19, 19, 1)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: state.pageController,
                  onPageChanged: (index) => context
                      .read<AlbumFrameCubit>()
                      .initalizeImageFrameWithSelectedImage(index),
                  itemCount: state.imageFrameTimelineList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 4 / 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(19, 19, 19, 1),
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  state.imageFrameTimelineList[index].imageReq,
                                  headers: headers,
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.0,
                  vertical: 8,
                ),
                child: ImageFrameMetadataRow(),
              )
            ],
          ),
        );
      },
    );
  }
}
