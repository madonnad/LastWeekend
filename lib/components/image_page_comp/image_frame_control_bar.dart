import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/image_frame_dialog.dart';

class ImageFrameControlBar extends StatelessWidget {
  const ImageFrameControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => context.read<AlbumFrameCubit>().previousImage(),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 25,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 25),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              barrierColor: Colors.black87,
              builder: (ctx) => BlocProvider.value(
                value: BlocProvider.of<ImageFrameCubit>(context),
                child: const ImageFrameDialog(),
              ),
            ),
            child: const Icon(
              Icons.view_timeline,
              size: 25,
              color: Color.fromRGBO(225, 225, 225, 1),
            ),
          ),
          const SizedBox(width: 25),
          GestureDetector(
            onTap: () => context.read<AlbumFrameCubit>().nextImage(),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 25,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
