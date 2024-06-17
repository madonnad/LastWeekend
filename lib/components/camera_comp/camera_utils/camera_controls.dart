import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/camera_utils/shutter_button.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/captured_edit_screen.dart';

class CameraControls extends StatelessWidget {
  final CameraController controller;
  final VoidCallback flipCamera;
  const CameraControls(
      {super.key, required this.controller, required this.flipCamera});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: flipCamera,
              child: const Icon(
                Icons.flip_camera_ios_sharp,
                color: Colors.white,
              ),
            ),
            ShutterButton(controller: controller),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.flash_off,
                color: Colors.white,
              ),
            ),
            const Spacer(),
          ],
        ),
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            enableDrag: false,
            builder: (ctx) {
              return BlocProvider.value(
                value: context.read<CameraCubit>(),
                child: const CapturedEditScreen(),
              );
            },
          ),
          child: const Text(
            "😅",
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }
}
