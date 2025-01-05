import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class MiniMapImage extends StatelessWidget {
  final bool isImage;
  final String imageReq;

  const MiniMapImage({
    super.key,
    required this.isImage,
    required this.imageReq,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(19, 19, 19, 1),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            imageReq,
            headers: context.read<AppBloc>().state.user.headers,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isImage
              ? const Color.fromRGBO(255, 205, 178, 1)
              : Colors.transparent,
          width: 2,
        ),
      ),
    );
  }
}
