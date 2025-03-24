import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';

class FloatingCommentContainer extends StatelessWidget {
  final Map<String, String> headers;
  const FloatingCommentContainer({required this.headers, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageFrameCubit, ImageFrameState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom,
          ),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(34, 34, 38, 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(19, 19, 20, 1),
                spreadRadius: 20,
                blurRadius: 10,
                offset: Offset(0, 10), // changes position of shadow
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: state.commentController,
                    onTapOutside: (_) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    onChanged: (_) =>
                        context.read<ImageFrameCubit>().commentTextChange(),
                    maxLines: null,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Comment",
                      hintStyle: GoogleFonts.lato(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: state.canAddComment
                          ? () => context.read<ImageFrameCubit>().postComment()
                          : null,
                      icon: const Icon(Icons.comment_rounded),
                      color: Colors.white,
                      disabledColor: Colors.white54,
                      iconSize: 25,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
