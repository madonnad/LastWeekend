import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/camera_utils/shutter_button.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/captured_edit_screen.dart';

class CameraControls extends StatefulWidget {
  final CameraController controller;
  final VoidCallback flipCamera;
  const CameraControls(
      {super.key, required this.controller, required this.flipCamera});

  @override
  State<CameraControls> createState() => _CameraControlsState();
}

class _CameraControlsState extends State<CameraControls> {
  IconData icon = Icons.flash_auto;
  int flashMode = 0;

  Future<void> changeFlashMode() async {
    switch (flashMode) {
      case 0:
        await widget.controller.setFlashMode(FlashMode.always);
        setState(() {
          icon = Icons.flash_on;
          flashMode = 1;
        });
      case 1:
        await widget.controller.setFlashMode(FlashMode.off);
        setState(() {
          icon = Icons.flash_off;
          flashMode = 2;
        });
      case 2:
        await widget.controller.setFlashMode(FlashMode.auto);
        setState(() {
          icon = Icons.flash_auto;
          flashMode = 0;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: widget.flipCamera,
              child: const Icon(
                Icons.flip_camera_ios_sharp,
                color: Colors.white,
              ),
            ),
            ShutterButton(controller: widget.controller),
            GestureDetector(
              onTap: () {
                changeFlashMode();
              },
              child: Icon(
                icon,
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
          child: const Icon(
            Icons.library_add,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
