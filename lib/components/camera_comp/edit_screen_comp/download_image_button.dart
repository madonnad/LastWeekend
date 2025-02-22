import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';

class DownloadImageButton extends StatefulWidget {
  const DownloadImageButton({super.key});

  @override
  State<DownloadImageButton> createState() => _DownloadImageButtonState();
}

class _DownloadImageButtonState extends State<DownloadImageButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isAnimated = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
  }

  void startCheckAnimation(AnimationController controller) async {
    setState(() {
      isAnimated = true;
    });
    await controller.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 750));
    });

    controller.reset();

    setState(() {
      isAnimated = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        context.read<CameraCubit>().downloadImageToDevice();
        startCheckAnimation(controller);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 98, 96, 1),
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: isAnimated
            ? AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) => LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [controller.value, controller.value + .25],
                      colors: const [
                        Colors.white,
                        Colors.transparent,
                      ],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.check,
                      size: 24,
                      weight: 10,
                    ),
                  );
                },
              )
            : const Icon(
                Icons.save,
                size: 24,
                color: Colors.white,
              ),
      ),
    );
  }
}
