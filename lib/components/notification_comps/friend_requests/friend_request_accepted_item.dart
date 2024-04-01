import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class FriendRequestAcceptedItem extends StatelessWidget {
  final String firstName;
  final String profileImage;
  final String requesterID;
  const FriendRequestAcceptedItem({
    super.key,
    required this.firstName,
    required this.profileImage,
    required this.requesterID,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      padding: const EdgeInsets.only(left: 10, right: 15),
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(44, 44, 44, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
            foregroundImage: NetworkImage(
              profileImage,
              headers: context.read<AppBloc>().state.user.headers,
            ),
            onForegroundImageError: (_, __) {},
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$firstName's now your friend! 🥳",
              style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              '/friend',
              arguments: requesterID,
            ),
            child: Text(
              "Profile",
              style: GoogleFonts.josefinSans(
                color: const Color.fromRGBO(149, 149, 149, 1),
                decoration: TextDecoration.underline,
                decorationColor: const Color.fromRGBO(149, 149, 149, 1),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
