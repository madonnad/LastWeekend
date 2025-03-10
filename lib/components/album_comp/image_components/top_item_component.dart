import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/new_image_frame.dart';

class TopItemComponent extends StatelessWidget {
  final Photo image;
  final bool showCount;
  final Map<String, String> headers;
  const TopItemComponent({
    super.key,
    required this.image,
    required this.showCount,
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
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              context
                  .read<AlbumFrameCubit>()
                  .initalizeImageFrameWithSelectedImage(image);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                useSafeArea: true,
                isDismissible: false,
                barrierColor: Color.fromRGBO(19, 19, 20, 1),
                builder: (ctx) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ImageFrameCubit(
                        dataRepository: context.read<DataRepository>(),
                        user: context.read<AppBloc>().state.user,
                        image: image,
                        albumID: albumID,
                      ),
                    ),
                    BlocProvider.value(
                      value: context.read<AlbumFrameCubit>(),
                    ),
                  ],
                  child: NewImageFrame(
                    index: selectedIndex,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(44, 44, 44, .75),
                borderRadius: BorderRadius.circular(00),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    image.imageReq540,
                    headers: headers,
                    errorListener: (_) {},
                  ),
                  onError: (_, __) {},
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
