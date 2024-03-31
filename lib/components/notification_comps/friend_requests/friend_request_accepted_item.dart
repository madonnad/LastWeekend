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
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 75,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(19, 19, 19, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
            foregroundImage: NetworkImage(
              profileImage,
              headers: context.read<AppBloc>().state.user.headers,
            ),
            onForegroundImageError: (_, __) {},
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'You & $firstName',
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "are now friends! 🥳",
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
              '/friend',
              arguments: requesterID,
            ),
            child: Text(
              "Go to profile",
              style: GoogleFonts.josefinSans(
                color: const Color.fromRGBO(229, 152, 155, 1),
                decoration: TextDecoration.underline,
                decorationColor: const Color.fromRGBO(229, 152, 155, 1),
                fontSize: 16,
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
