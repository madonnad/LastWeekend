import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/profile_comp/friends_comp/friends_bottom_modal_sheet.dart';

class FriendGestureText extends StatelessWidget {
  const FriendGestureText({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const FriendsBottomModalSheet(),
          ),
          child: Text(
            '${state.myFriends.length} Friends',
            style: GoogleFonts.poppins(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        );
      },
    );
  }
}
