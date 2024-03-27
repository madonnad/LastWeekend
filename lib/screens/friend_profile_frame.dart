import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/components/friend_profile_comp/friend_profile_header.dart';
import 'package:shared_photo/components/friend_profile_comp/friend_status_logic.dart';
import 'package:shared_photo/components/friend_profile_comp/friends_album_section.dart';
import 'package:shared_photo/components/friend_profile_comp/joint_album_section.dart';
import 'package:shared_photo/components/friend_profile_comp/not_friends_comp.dart';

class FriendProfileFrame extends StatelessWidget {
  const FriendProfileFrame({super.key});

  @override
  Widget build(BuildContext context) {
    double paddingHeight =
        MediaQuery.of(context).viewPadding.top + kToolbarHeight;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: BlocBuilder<FriendProfileCubit, FriendProfileState>(
        builder: (context, state) {
          return state.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: paddingHeight,
                    left: 16,
                    right: 16,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FriendProfileHeader(),
                      SizedBox(height: 10),
                      FriendStatusLogic(),
                      NotFriendsComp(),
                      JointAlbumSection(),
                      FriendsAlbumSection(),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
