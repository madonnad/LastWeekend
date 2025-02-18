import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';

class CameraNavElement extends StatelessWidget {
  final int index;

  const CameraNavElement({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppFrameCubit, AppFrameState>(
      builder: (context, state) {
        if (state.index == index) {
          return GestureDetector(
            child: const Icon(
              Icons.camera_alt,
              size: 30,
              color: Color.fromRGBO(34, 34, 38, 1),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => context.read<AppFrameCubit>().changePage(index),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 30,
              color: Color.fromRGBO(78, 78, 78, 1),
            ),
          );
        }
      },
    );
  }
}
