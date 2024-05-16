import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/photo.dart' as img;
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/image_frame.dart';

class TopItemComponent extends StatelessWidget {
  final double radius;
  final img.Photo image;
  final Map<String, String> headers;
  const TopItemComponent({
    super.key,
    required this.image,
    required this.radius,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    String albumID = context.read<AlbumFrameCubit>().albumID;

    int selectedIndex = context
        .read<AlbumFrameCubit>()
        .state
        .imageFrameTimelineList
        .indexOf(image);
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              context
                  .read<AlbumFrameCubit>()
                  .initalizeImageFrameWithSelectedImage(selectedIndex);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                useSafeArea: true,
                builder: (ctx) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ImageFrameCubit(
                        dataRepository: context.read<DataRepository>(),
                        image: image,
                        albumID: albumID,
                      ),
                    ),
                    BlocProvider.value(
                      value: context.read<AlbumFrameCubit>(),
                    ),
                  ],
                  child: const ImageFrame(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(44, 44, 44, .75),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                    image.imageReq,
                    headers: headers,
                  ),
                  onError: (_, __) {},
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(radius),
              elevation: 2,
              child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
                foregroundImage: CachedNetworkImageProvider(
                  image.avatarReq,
                  headers: headers,
                ),
                radius: radius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
