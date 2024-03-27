import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/feed_comp/dashboard/list_album_component.dart';
import 'package:shared_photo/models/friend.dart';

class JointAlbumSection extends StatelessWidget {
  const JointAlbumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: BlocBuilder<FriendProfileCubit, FriendProfileState>(
        builder: (context, state) {
          if (state.anonymousFriend.friendStatus == FriendStatus.friends) {
            if (state.friendJointAlbumList.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeaderSmall(
                      "You and ${state.anonymousFriend.firstName}"),
                  SizedBox(
                    height: 300,
                    child: ListView.separated(
                      itemCount: state.friendJointAlbumList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return ListAlbumComponent(
                            album: state.friendJointAlbumList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: 10,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  "No Albums Together Yet 😔",
                  style: GoogleFonts.josefinSans(
                    color: Colors.white.withOpacity(.75),
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              );
            }
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
