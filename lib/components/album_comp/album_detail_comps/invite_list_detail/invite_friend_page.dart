import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invite_list_titlebar.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invited_button.dart';
import 'package:shared_photo/models/friend.dart';
import 'package:shared_photo/repositories/user_repository.dart';

class InviteFriendPage extends StatelessWidget {
  final PageController controller;
  const InviteFriendPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    List<Friend> friendList =
        context.read<UserRepository>().friendMap.values.toList();

    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewPadding.bottom + 15,
          ),
          child: Column(
            children: [
              InviteListTitlebar(
                title: "Invite Friends",
                icon: Icons.arrow_back_ios,
                onTap: () => controller.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear,
                ),
              ),
              const Gap(15),
              Expanded(
                child: ListView.builder(
                  itemCount: friendList.length,
                  itemBuilder: (context, index) {
                    String guestUID = friendList[index].uid;
                    bool isInvited = state.album.guestMap.values
                        .any((guest) => guest.uid == guestUID);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      const Color.fromRGBO(16, 16, 16, 1),
                                  foregroundImage: CachedNetworkImageProvider(
                                    friendList[index].imageReq540,
                                    headers: context
                                        .read<AppBloc>()
                                        .state
                                        .user
                                        .headers,
                                  ),
                                  radius: 18,
                                  onForegroundImageError: (_, __) {},
                                ),
                                const Gap(15),
                                Expanded(
                                  child: Text(
                                    friendList[index].fullName,
                                    style: GoogleFonts.josefinSans(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  ),
                                ),
                                const Gap(25),
                              ],
                            ),
                          ),
                          InvitedButton(
                            isInvited: isInvited,
                            onTap: () => context
                                .read<AlbumFrameCubit>()
                                .sendInviteToFriends(
                                  guestUID,
                                  friendList[index].firstName,
                                  friendList[index].lastName,
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
