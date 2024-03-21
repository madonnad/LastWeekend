import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';

class FloatingCommentContainer extends StatelessWidget {
  final Map<String, String> headers;
  const FloatingCommentContainer({required this.headers, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageFrameCubit, ImageFrameState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 15),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(44, 44, 44, 1),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 20,
                  blurRadius: 10,
                  offset: Offset(0, 10), // changes position of shadow
                )
              ],
            ),
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      onTapOutside: (_) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      maxLines: null,
                      style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Add Comment",
                        hintStyle: GoogleFonts.josefinSans(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.comment_rounded),
                        color: Colors.white,
                        disabledColor: Colors.white54,
                        iconSize: 25,
                      ),
                      IconButton(
                        onPressed: state.likeLoading
                            ? null
                            : () =>
                                context.read<ImageFrameCubit>().toggleLike(),
                        icon: state.image.userLiked
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_outline),
                        color: Colors.white,
                        disabledColor: Colors.white54,
                        iconSize: 25,
                      ),
                      Transform.rotate(
                        angle: (270 * math.pi) / 180,
                        child: IconButton(
                          onPressed: state.upvoteLoading
                              ? null
                              : () => context
                                  .read<ImageFrameCubit>()
                                  .toggleUpvote(),
                          icon: state.image.userUpvoted
                              ? const Icon(Icons.label_important)
                              : const Icon(Icons.label_important_outline),
                          color: Colors.white,
                          disabledColor: Colors.white54,
                          iconSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
