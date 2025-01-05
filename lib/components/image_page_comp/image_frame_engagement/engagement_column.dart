import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/image_comment_dialog.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_dialog/more_img_opts_dialog.dart';
import 'package:shared_photo/components/image_page_comp/image_frame_engagement/image_engagement_icon.dart';

class EngagementColumn extends StatelessWidget {
  final bool isInEvent;
  final bool isReveal;
  final bool canSave;
  const EngagementColumn({
    super.key,
    required this.isInEvent,
    required this.isReveal,
    required this.canSave,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageFrameCubit, ImageFrameState>(
      builder: (context, state) {
        bool userLiked = state.image.userLiked;
        bool userUpvoted = state.image.userUpvoted;
        String numComments = state.image.comments.length.toString();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
              ),
              child: ImageEngagementIcon(
                onTap: () {
                  state.upvoteLoading
                      ? null
                      : context.read<ImageFrameCubit>().toggleUpvote();
                },
                text: state.image.upvotes.toString(),
                userEngaged: userUpvoted,
                defaultIcon: Icons.forward_outlined,
                secondaryIcon: Icons.forward,
                rotation: 270,
                showIcon: isInEvent && isReveal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
              ),
              child: ImageEngagementIcon(
                onTap: () {
                  state.likeLoading
                      ? null
                      : context.read<ImageFrameCubit>().toggleLike();
                },
                text: state.image.likes.toString(),
                userEngaged: userLiked,
                defaultIcon: Icons.favorite_outline,
                secondaryIcon: Icons.favorite,
                showIcon: isReveal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
              ),
              child: ImageEngagementIcon(
                onTap: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value: context.read<AlbumFrameCubit>(),
                      ),
                      BlocProvider.value(
                        value: context.read<ImageFrameCubit>(),
                      ),
                    ],
                    child: ImageCommentDialog(),
                  ),
                ),
                text: numComments,
                defaultIcon: Icons.comment,
                showIcon: isReveal,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.0,
              ),
              child: ImageEngagementIcon(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) {
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<AlbumFrameCubit>(),
                          ),
                          BlocProvider.value(
                            value: context.read<ImageFrameCubit>(),
                          ),
                        ],
                        child: MoreImageOptsDialog(
                          canSave: canSave,
                        ),
                      );
                    },
                  );
                },
                defaultIcon: Icons.more_horiz,
                rotation: 270,
                showIcon: true,
              ),
            ),
          ],
        );
      },
    );
  }
}
