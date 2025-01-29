import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/guest.dart';

class EventGuestRow extends StatelessWidget {
  final List<Guest> guestList;
  const EventGuestRow({super.key, required this.guestList});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argMap = {
      'albumFrameCubit': context.read<AlbumFrameCubit>(),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed('/event-people', arguments: argMap),
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Guests",
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        Gap(5),
        Container(
          height: 70,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: guestList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(width: 0);
              }

              return AvatarListItem(
                avatarURL: guestList[index - 1].avatarReq540,
                name: guestList[index - 1].firstName,
                guestID: guestList[index - 1].uid,
              );
            },
            separatorBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(width: 0);
              }
              return SizedBox(width: 10);
            },
          ),
        ),
      ],
    );
  }
}

class AvatarListItem extends StatelessWidget {
  final String avatarURL;
  final String name;
  final String guestID;
  const AvatarListItem({
    super.key,
    required this.avatarURL,
    required this.name,
    required this.guestID,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argMap = {
      'albumFrameCubit': context.read<AlbumFrameCubit>(),
      'guestID': guestID,
    };
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/guest', arguments: argMap),
      child: SizedBox(
        width: 70,
        child: Column(
          children: [
            Expanded(
              child: CircleAvatar(
                backgroundColor: Color.fromRGBO(44, 44, 44, 1),
                backgroundImage: AssetImage("lib/assets/placeholder.png"),
                foregroundImage: CachedNetworkImageProvider(
                  avatarURL,
                  headers: context.read<AppBloc>().state.user.headers,
                  errorListener: (_) {},
                ),
                radius: 50,
              ),
            ),
            // Text(
            //   name,
            //   style: GoogleFonts.montserrat(
            //     color: Colors.white,
            //     fontSize: 14,
            //     fontWeight: FontWeight.w500,
            //   ),
            //   textAlign: TextAlign.center,
            //   overflow: TextOverflow.ellipsis,
            //   maxLines: 1,
            // ),
          ],
        ),
      ),
    );
  }
}
