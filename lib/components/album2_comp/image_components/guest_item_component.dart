import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/new_album_frame_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/image.dart' as img;
import 'package:shared_photo/screens/image_frame.dart';

class GuestItemComponent extends StatelessWidget {
  final img.Image image;
  final Map<String, String> headers;

  const GuestItemComponent({
    super.key,
    required this.image,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    Album album = context.read<NewAlbumFrameCubit>().album;
    AlbumViewMode viewMode = context.read<NewAlbumFrameCubit>().state.viewMode;

    int selectedIndex = context
        .read<NewAlbumFrameCubit>()
        .state
        .selectedModeImages
        .indexOf(image);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          useSafeArea: true,
          builder: (ctx) => BlocProvider(
            create: (context) => ImageFrameCubit(
              image: image,
              album: album,
              viewMode: viewMode,
              initialIndex: selectedIndex,
              token: context.read<AppBloc>().state.user.token,
            ),
            child: ImageFrame(
              image: image,
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 4 / 5,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(44, 44, 44, .75),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                image.imageReq,
                headers: headers,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
