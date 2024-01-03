import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
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
                    top: kToolbarHeight,
                    left: 10,
                    right: 10,
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ImageFrameAppBar(),
                      Container(
                        height: MediaQuery.of(context).size.height * .6,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color.fromRGBO(19, 19, 19, 1)
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: state.pageController,
                                onPageChanged: (index) => context
                                    .read<ImageFrameCubit>()
                                    .imageChange(index),
                                itemCount: state.selectedModeImages.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              19, 19, 19, 1),
                                          image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                state.selectedModeImages[index]
                                                    .imageReq,
                                                headers: headers,
                                              ),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                                vertical: 8,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                textBaseline: TextBaseline.alphabetic,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        state.selectedImage.upvotes.toString(),
                                        style: GoogleFonts.josefinSans(
                                          fontSize: 18,
                                          color: Colors.white,
                                          textBaseline: TextBaseline.alphabetic,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    state.selectedImage.dateString,
                                    style: GoogleFonts.josefinSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white.withOpacity(.75),
                                      textBaseline: TextBaseline.alphabetic,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
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
                                builder: (context) {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.red,
                                  );
                                },
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
