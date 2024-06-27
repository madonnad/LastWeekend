import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/image_frame.dart';

class FirstItemComponent extends StatelessWidget {
  final Photo image;
  final Map<String, String> headers;
  const FirstItemComponent(
      {super.key, required this.image, required this.headers});

  @override
  Widget build(BuildContext context) {
    String albumID = context.read<AlbumFrameCubit>().albumID;

    int selectedIndex = context
        .read<AlbumFrameCubit>()
        .state
        .imageFrameTimelineList
        .indexOf(image);
    return GestureDetector(
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
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(19, 19, 19, 1),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      image.imageReq,
                      headers: headers,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 75,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  //color: Colors.black.withOpacity(.6),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(.85),
                      Colors.black.withOpacity(.5),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 2.5,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(255, 205, 178, 1),
                            Color.fromRGBO(255, 180, 162, 1),
                            Color.fromRGBO(229, 152, 155, 1),
                            Color.fromRGBO(181, 131, 141, 1),
                            Color.fromRGBO(109, 104, 117, 1),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              image.imageCaption,
                              style: GoogleFonts.josefinSans(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor:
                                    const Color.fromRGBO(44, 44, 44, 1),
                                foregroundImage: NetworkImage(
                                  image.avatarReq,
                                  headers: headers,
                                ),
                                onForegroundImageError: (_, __) {},
                              ),
                              const Gap(5),
                              Text(
                                image.fullName,
                                style: GoogleFonts.josefinSans(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          image.upvotes.toString(),
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Transform.rotate(
                          angle: (270 * math.pi) / 180,
                          child: const Icon(
                            Icons.label_important,
                            color: Colors.white,
                            size: 20,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
