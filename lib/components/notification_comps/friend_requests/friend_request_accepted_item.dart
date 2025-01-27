import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class FriendRequestAcceptedItem extends StatelessWidget {
  final String firstName;
  final String profileImage;
  final String userID;
  const FriendRequestAcceptedItem({
    super.key,
    required this.firstName,
    required this.profileImage,
    required this.userID,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            foregroundImage: CachedNetworkImageProvider(
              profileImage,
              headers: context.read<AppBloc>().state.user.headers,
              errorListener: (_) {},
            ),
            onForegroundImageError: (_, __) {},
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$firstName's now your friend! 🥳",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              '/friend',
              arguments: userID,
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
