import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/camera_utils/shutter_button.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/screens/captured_image_list_screen.dart';

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
    final ImagePicker imagePicker = ImagePicker();

    void addListPhotos(List<XFile>? selectedImages) {
      if (selectedImages == null) return;

      context
          .read<CameraCubit>()
          .addListOfPhotosToList(selectedImages, UploadType.forgotShot);
    }

    void pushCapturedPage() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => BlocProvider<CameraCubit>.value(
            value: context.read<CameraCubit>(),
            child:
                const CapturedImageListScreen(), //const CapturedEditScreen(),
          ),
        ),
      );
    }

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
          onTap: () async {
            List<XFile>? selectedImages;
            selectedImages = await imagePicker
                .pickMultiImage(maxHeight: 2160, maxWidth: 2160)
                .whenComplete(() {
              if (selectedImages != null) {
                pushCapturedPage();
              }
            });
            addListPhotos(selectedImages);
          },
          child: const Icon(
            Icons.library_add,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
