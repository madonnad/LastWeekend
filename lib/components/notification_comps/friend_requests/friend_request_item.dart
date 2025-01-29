import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/notification_comps/notification_button.dart';

class FriendRequestItem extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String profileImage;
  final String senderID;
  final String requestID;

  const FriendRequestItem({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.profileImage,
    required this.senderID,
    required this.requestID,
  });

  @override
  Widget build(BuildContext context) {
    String lastLetter = lastName[0];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            foregroundImage: CachedNetworkImageProvider(
              profileImage,
              headers: context.read<AppBloc>().state.user.headers,
              errorListener: (_) {},
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
                    '$firstName $lastLetter.',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "wants to be friends",
                    style: GoogleFonts.josefinSans(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Row(
            children: [
              NotificationButton(
                buttonText: "Deny",
                backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                onTap: () => context
                    .read<NotificationCubit>()
                    .denyFriendRequest(requestID),
              ),
              const SizedBox(width: 15),
              NotificationButton(
                buttonText: "Accept",
                backgroundColor: const Color.fromRGBO(181, 131, 141, 1),
                onTap: () =>
                    context.read<NotificationCubit>().acceptFriendRequest(
                          requestID: requestID,
                          senderID: senderID,
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
