import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/notification_cubit.dart';
import 'package:shared_photo/components/notification_comps/notification_button.dart';

class AlbumRequestItem extends StatelessWidget {
  final String profileImage;
  final String albumCover;
  final String firstName;
  final String albumName;
  final String requestID;
  const AlbumRequestItem({
    super.key,
    required this.profileImage,
    required this.albumCover,
    required this.firstName,
    required this.albumName,
    required this.requestID,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 100,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(19, 19, 19, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(height: 25),
            ],
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
                    "$firstName is inviting you to",
                    style: GoogleFonts.josefinSans(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    albumName,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Gap(5),
                Row(
                  children: [
                    NotificationButton(
                      buttonText: "Deny",
                      backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                      onTap: () => context
                          .read<NotificationCubit>()
                          .denyAlbumInvite(requestID: requestID),
                    ),
                    const SizedBox(width: 15),
                    NotificationButton(
                      buttonText: "Accept",
                      backgroundColor: const Color.fromRGBO(255, 98, 96, 1),
                      onTap: () => context
                          .read<NotificationCubit>()
                          .acceptAlbumInvite(requestID: requestID),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: AspectRatio(
              aspectRatio: 60 / 65,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(44, 44, 44, 1),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      albumCover,
                      headers: context.read<AppBloc>().state.user.headers,
                      errorListener: (_) {},
                    ),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
