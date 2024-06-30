import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/arguments.dart';

class AcceptedAlbumItem extends StatelessWidget {
  final String albumID;
  final String profileImage;
  final String firstName;
  final String albumName;
  final String timeSince;
  const AcceptedAlbumItem({
    super.key,
    required this.albumID,
    required this.profileImage,
    required this.firstName,
    required this.albumName,
    required this.timeSince,
  });

  @override
  Widget build(BuildContext context) {
    Arguments arguments = Arguments(albumID: albumID);
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed('/album', arguments: arguments),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
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
              ),
              onForegroundImageError: (_, __) {},
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$firstName accepted your invite to",
                    style: GoogleFonts.josefinSans(
                      color: Colors.white60,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    albumName,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  timeSince,
                  style: GoogleFonts.josefinSans(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
