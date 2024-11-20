import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/image_frame.dart';

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
                  .initalizeImageFrameWithSelectedImage(selectedIndex);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                useSafeArea: true,
                isDismissible: false,
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
                  child: const ImageFrame(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(44, 44, 44, .75),
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    image.imageReq,
                    headers: headers,
                  ),
                  onError: (_, __) {},
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: Row(
          //     children: [
          //       Container(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 5,
          //           vertical: 5,
          //         ),
          //         decoration: BoxDecoration(
          //           color: Colors.black.withOpacity(0.6),
          //           borderRadius: const BorderRadius.only(
          //             bottomLeft: Radius.circular(10),
          //             topRight: Radius.circular(10),
          //           ),
          //         ),
          //         child: showCount
          //             ? Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   CircleAvatar(
          //                     backgroundColor:
          //                         const Color.fromRGBO(16, 16, 16, 1),
          //                     foregroundImage: CachedNetworkImageProvider(
          //                       image.avatarReq,
          //                       headers: headers,
          //                     ),
          //                     radius: 10,
          //                   ),
          //                   const Gap(5),
          //                   Container(
          //                     width: 1.5,
          //                     height: 25,
          //                     decoration: const BoxDecoration(
          //                       gradient: LinearGradient(
          //                         colors: [
          //                           Color.fromRGBO(255, 205, 178, 1),
          //                           Color.fromRGBO(255, 180, 162, 1),
          //                           Color.fromRGBO(229, 152, 155, 1),
          //                           Color.fromRGBO(181, 131, 141, 1),
          //                           Color.fromRGBO(109, 104, 117, 1),
          //                         ],
          //                         begin: Alignment.bottomCenter,
          //                         end: Alignment.topCenter,
          //                       ),
          //                     ),
          //                   ),
          //                   const Gap(5),
          //                   Row(
          //                     children: [
          //                       Text(
          //                         image.upvotes.toString(),
          //                         style: GoogleFonts.montserrat(
          //                           color: Colors.white,
          //                           fontSize: 16,
          //                           fontWeight: FontWeight.w600,
          //                         ),
          //                       ),
          //                       Transform.rotate(
          //                         angle: (270 * math.pi) / 180,
          //                         child: const Icon(
          //                           Icons.label_important,
          //                           color: Colors.white,
          //                           size: 10,
          //                         ),
          //                       )
          //                     ],
          //                   )
          //                 ],
          //               )
          //             : CircleAvatar(
          //                 backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
          //                 foregroundImage: CachedNetworkImageProvider(
          //                   image.avatarReq,
          //                   headers: headers,
          //                 ),
          //                 radius: 9,
          //               ),
          //       ),
          //       const Expanded(child: SizedBox.shrink())
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
