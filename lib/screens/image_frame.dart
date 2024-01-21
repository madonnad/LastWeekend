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
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: ImageFrameAppBar()),
                    const SliverToBoxAdapter(child: ImageFrameImageContainer()),
                    SliverToBoxAdapter(
                      child: Padding(
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
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                          bottom: 10.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  const Color.fromRGBO(25, 25, 25, 1),
                              foregroundImage: CachedNetworkImageProvider(
                                state.selectedImage.avatarReq,
                                headers: headers,
                              ),
                              radius: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.selectedImage.fullName,
                                    style: GoogleFonts.josefinSans(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.selectedImage.imageCaption,
                                          style: GoogleFonts.josefinSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 5,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      const Color.fromRGBO(25, 25, 25, 1),
                                  foregroundImage: CachedNetworkImageProvider(
                                    state
                                        .selectedImage.comments[item].avatarReq,
                                    headers: headers,
                                  ),
                                  radius: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            state.selectedImage.comments[item]
                                                .fullName,
                                            style: GoogleFonts.josefinSans(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            state.selectedImage.comments[item]
                                                .shortTime,
                                            style: GoogleFonts.josefinSans(
                                              color: Colors.white54,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              state.selectedImage.comments[item]
                                                  .comment,
                                              style: GoogleFonts.josefinSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: state.selectedImage.comments.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).padding.bottom,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(44, 44, 44, 1),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, -3), // changes position of shadow
                    )
                  ],
                ),
                height: 100,
              ),
            ),
          ],
        );
      },
    );
  }
}
