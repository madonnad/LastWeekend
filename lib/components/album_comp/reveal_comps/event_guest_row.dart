import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/guest.dart';

class EventGuestRow extends StatelessWidget {
  final List<Guest> guestList;
  const EventGuestRow({super.key, required this.guestList});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "People",
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(10),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: guestList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(width: 0);
                }
                return AvatarListItem(
                  avatarURL: guestList[index - 1].avatarReqSmall,
                  name: guestList[index - 1].firstName,
                );
              },
              separatorBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(width: 0);
                }
                return SizedBox(width: 20);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarListItem extends StatelessWidget {
  final String avatarURL;
  final String name;
  const AvatarListItem({
    super.key,
    required this.avatarURL,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Color.fromRGBO(44, 44, 44, 1),
            foregroundImage: CachedNetworkImageProvider(
              avatarURL,
              headers: context.read<AppBloc>().state.user.headers,
            ),
            radius: 32,
          ),
          Text(
            name,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
