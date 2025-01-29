import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/image_frame_comp/image_frame_dialog/image_comment_dialog.dart';
import 'package:shared_photo/components/image_frame_comp/image_frame_engagement/image_engagement_icon.dart';
import 'package:shared_photo/models/album.dart';

class UserEngagementRow extends StatelessWidget {
  final Map<String, String> headers;
  const UserEngagementRow({super.key, required this.headers});

  @override
  Widget build(BuildContext context) {
    String userID = context.read<AppBloc>().state.user.id;
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, albumState) {
        bool isInEvent = albumState.album.guestMap.containsKey(userID);
        bool isReveal = albumState.album.phase == AlbumPhases.reveal;

        return BlocBuilder<ImageFrameCubit, ImageFrameState>(
          builder: (context, state) {
            bool userUpvoted = state.image.userUpvoted;
            bool captionExists = state.image.imageCaption != '';
            bool isOwner = state.image.owner == userID;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromRGBO(25, 25, 25, 1),
                          foregroundImage: CachedNetworkImageProvider(
                            state.image.avatarReq540,
                            headers: headers,
                            errorListener: (_) {},
                          ),
                          radius: 16,
                        ),
                        Gap(8),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (captionExists && isReveal ||
                                      captionExists && isOwner)
                                  ? Text(
                                      state.image.imageCaption,
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                    )
                                  : SizedBox.shrink(),
                              Text(
                                state.image.fullName,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(50),
                  Row(
                    children: [
                      ImageEngagementIcon(
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
                        defaultIcon: Icons.comment_outlined,
                        iconSize: 30,
                        showIcon: isReveal,
                        primaryColor: Colors.white,
                        text: state.image.comments.length.toString(),
                      ),
                      Gap(isInEvent ? 20 : 0),
                      isInEvent
                          ? ImageEngagementIcon(
                              onTap: () => state.upvoteLoading
                                  ? null
                                  : context
                                      .read<ImageFrameCubit>()
                                      .toggleUpvote(),
                              defaultIcon: Icons.arrow_back_ios_new_outlined,
                              rotation: 90,
                              showIcon: isReveal,
                              iconSize: 30,
                              primaryColor: Colors.white,
                              secondaryColor: Color.fromRGBO(255, 180, 162, 1),
                              userEngaged: userUpvoted,
                              text: state.image.upvotes.toString(),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
