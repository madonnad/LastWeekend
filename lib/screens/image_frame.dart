import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_container/image_frame_image_container.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/image_frame_dialog.dart';
import 'package:shared_photo/models/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_appbar.dart';

class ImageFrame extends StatelessWidget {
  final img.Image image;
  const ImageFrame({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageFrameCubit, ImageFrameState>(
      builder: (context, state) {
        Map<String, String> headers =
            context.read<AppBloc>().state.user.headers;
        return Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ImageFrameAppBar(),
                      const ImageFrameImageContainer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => context
                                  .read<ImageFrameCubit>()
                                  .previousImage(),
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
                                  value:
                                      BlocProvider.of<ImageFrameCubit>(context),
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
                              onTap: () =>
                                  context.read<ImageFrameCubit>().nextImage(),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        height: 400,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 110,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).padding.bottom + 10,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(44, 44, 44, 1),
                    borderRadius: BorderRadius.circular(15)),
                height: 100,
              ),
            ),
          ],
        );
      },
    );
  }
}
