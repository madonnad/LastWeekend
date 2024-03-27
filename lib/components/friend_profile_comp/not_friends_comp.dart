import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/models/friend.dart';

class NotFriendsComp extends StatelessWidget {
  const NotFriendsComp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendProfileCubit, FriendProfileState>(
      builder: (context, state) {
        return state.anonymousFriend.friendStatus != FriendStatus.friends
            ? Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(19, 19, 19, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text("🙈", style: TextStyle(fontSize: 64)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Add friend to view full profile".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.josefinSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
