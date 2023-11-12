import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/new_app_frame_cubit.dart';

class CameraNavElement extends StatelessWidget {
  final int index;

  const CameraNavElement({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewAppFrameCubit, NewAppFrameState>(
      builder: (context, state) {
        if (state.index == index) {
          return GestureDetector(
            child: const Icon(
              Icons.camera_alt,
              size: 30,
              color: Colors.black,
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => context.read<NewAppFrameCubit>().changePage(index),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 30,
              color: Color.fromRGBO(44, 44, 44, 1),
            ),
          );
        }
      },
    );
  }
}
