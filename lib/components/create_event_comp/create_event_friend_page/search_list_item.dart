import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/friend.dart';

class SearchListItem extends StatelessWidget {
  final Friend friend;
  final bool isInvited;
  const SearchListItem({
    super.key,
    required this.friend,
    required this.isInvited,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
          backgroundImage: const AssetImage("lib/assets/default.png"),
          foregroundImage: CachedNetworkImageProvider(
            friend.imageReq,
            headers: context.read<AppBloc>().state.user.headers,
          ),
          onForegroundImageError: (_, __) {},
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "${friend.firstName} ${friend.lastName}",
              style: GoogleFonts.josefinSans(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () =>
              context.read<CreateEventCubit>().handleFriendAddRemoveFromEvent(
                    friend,
                  ),
          child: isInvited
              ? const Icon(
                  Icons.check,
                  color: Colors.lightGreenAccent,
                )
              : const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white54,
                ),
        )
      ],
    );
  }
}
