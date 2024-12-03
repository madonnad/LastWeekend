import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/photo.dart';

class TrendingSlideshow extends StatefulWidget {
  final List<Photo> slideshowPhotos;
  const TrendingSlideshow({super.key, required this.slideshowPhotos});

  @override
  State<TrendingSlideshow> createState() => _TrendingSlideshowState();
}

class _TrendingSlideshowState extends State<TrendingSlideshow>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  String? shownImageUrl;
  int slideDuration = 12;
  int currentIndex = 0;
  int length = 0;

  @override
  void initState() {
    super.initState();

    if (widget.slideshowPhotos.isNotEmpty) {
      length = widget.slideshowPhotos.length;

      _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: slideDuration),
      );

      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _goToNextSlide();
        }
      });

      _controller.forward();
    }
  }

  void _goToNextSlide() {
    if (currentIndex < length - 1) {
      setState(() {
        currentIndex++;
      });
      _controller.reset();
      _controller.forward();
    } else {
      setState(() {
        currentIndex = 0;
      });
      _controller.reset();
      _controller.forward();
    }
  }

  void _goToPrevSlide() {
    if (currentIndex == 0) {
      _controller.reset();
      _controller.forward();
    } else {
      if (_controller.value < 0.05) {
        setState(() {
          currentIndex--;
        });
        _controller.reset();
        _controller.forward();
      } else {
        _controller.reset();
        _controller.forward();
      }
    }
  }

  void _pauseController() {
    _controller.stop();
  }

  void _resumeController() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.slideshowPhotos.isNotEmpty) {
      shownImageUrl = widget.slideshowPhotos[currentIndex].imageReq1080;
    }

    return shownImageUrl != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Trending",
              //   style: GoogleFonts.montserrat(
              //     color: Colors.white,
              //     fontSize: 18,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // Gap(8),
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 3 / 4,
                          child: CachedNetworkImage(
                            imageUrl: shownImageUrl!,
                            httpHeaders:
                                context.read<AppBloc>().state.user.headers,
                            fit: BoxFit.cover,
                          ),
                        ),
                        GestureDetector(
                          onLongPressUp: () => _resumeController(),
                          onLongPressDown: (_) => _pauseController(),
                          onLongPressCancel: () => _resumeController(),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                        GestureDetector(
                          onLongPressUp: () => _resumeController(),
                          onLongPressDown: (_) => _pauseController(),
                          onLongPressCancel: () => _resumeController(),
                          onTap: () => _goToPrevSlide(),
                          child: AspectRatio(
                            aspectRatio: 1 / 6,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onLongPressUp: () => _resumeController(),
                            onLongPressDown: (_) => _pauseController(),
                            onLongPressCancel: () => _resumeController(),
                            onTap: () => _goToNextSlide(),
                            child: AspectRatio(
                              aspectRatio: 1 / 6,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Container(
                          color: Colors.black38,
                          child: Row(
                            children: List.generate(
                              widget.slideshowPhotos.length,
                              (index) {
                                return Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: index < currentIndex
                                            ? Container(
                                                color: Colors.white,
                                                height: 5,
                                              )
                                            : index == currentIndex
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.white,
                                                          Colors.white24,
                                                        ],
                                                        stops: [
                                                          _controller.value,
                                                          _controller.value
                                                        ],
                                                      ),
                                                    ),
                                                    height: 5,
                                                  )
                                                : index > currentIndex
                                                    ? Container(
                                                        color: Colors.white24,
                                                        height: 5,
                                                      )
                                                    : Container(
                                                        color: Colors.white24,
                                                        height: 5,
                                                      ),
                                      ),
                                      index != widget.slideshowPhotos.length - 1
                                          ? Gap(5)
                                          : Gap(0),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      })
                ],
              ),
            ],
          )
        : SizedBox.shrink();
  }
}
