import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
//import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/models/search_result.dart';

class UserSearchResult extends StatelessWidget {
  final SearchResult result;
  const UserSearchResult({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    // bool isFriend =
    //     context.read<ProfileBloc>().state.myFriendsMap.containsKey(result.id);
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "${result.firstName} ${result.lastName}",
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
            backgroundImage: const AssetImage("lib/assets/placeholder.png"),
            foregroundImage: CachedNetworkImageProvider(
              result.imageReq,
              headers: context.read<AppBloc>().state.user.headers,
              errorListener: (_) {},
            ),
            onForegroundImageError: (_, __) {},
          ),
        ],
      ),
    );
  }
}
