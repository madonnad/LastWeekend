import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/models/guest.dart';

class InvitePage extends StatelessWidget {
  final Arguments arguments;
  const InvitePage({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    Album album = arguments.album;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 30, right: 30),
        child: ListView.builder(
          itemCount: album.sortedGuestsByInvite.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color.fromRGBO(16, 16, 16, 1),
                        foregroundImage: CachedNetworkImageProvider(
                          album.sortedGuestsByInvite[index].avatarReq,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        album.sortedGuestsByInvite[index].fullName,
                        style: GoogleFonts.josefinSans(
                          color: album.sortedGuestsByInvite[index].status ==
                                  InviteStatus.accept
                              ? Colors.white
                              : const Color.fromRGBO(125, 125, 125, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  album.sortedGuestsByInvite[index].status ==
                          InviteStatus.accept
                      ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.help_outline_outlined,
                          color: Color.fromRGBO(125, 125, 125, 1),
                        )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
