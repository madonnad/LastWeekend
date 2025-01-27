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
              style: GoogleFonts.josefinSans(
                fontSize: 20,
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

          // isFriend
          //     ? Container(
          //         decoration: BoxDecoration(
          //           color: const Color.fromRGBO(19, 19, 19, 1),
          //           borderRadius: BorderRadius.circular(10),
          //           border: Border.all(
          //             color: const Color.fromRGBO(181, 131, 141, 1),
          //             width: 2,
          //           ),
          //         ),
          //         padding:
          //             const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          //         child: Text(
          //           "Friends",
          //           style: GoogleFonts.montserrat(
          //             color: const Color.fromRGBO(181, 131, 141, 1),
          //             fontWeight: FontWeight.w700,
          //             fontSize: 14,
          //           ),
          //         ),
          //       )
          //     : Container(
          //         decoration: BoxDecoration(
          //           gradient: const LinearGradient(
          //             colors: [
          //               Color.fromRGBO(255, 205, 178, 1),
          //               Color.fromRGBO(255, 180, 162, 1),
          //               Color.fromRGBO(229, 152, 155, 1),
          //               Color.fromRGBO(181, 131, 141, 1),
          //               Color.fromRGBO(109, 104, 117, 1),
          //             ],
          //             begin: Alignment.topLeft,
          //             end: Alignment.bottomRight,
          //           ),
          //           borderRadius: BorderRadius.circular(10),
          //           border: Border.all(width: 2),
          //         ),
          //         padding:
          //             const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          //         child: Text(
          //           "Add",
          //           style: GoogleFonts.montserrat(
          //             color: const Color.fromRGBO(19, 19, 19, 1),
          //             fontWeight: FontWeight.w700,
          //             fontSize: 14,
          //           ),
          //         ),
          //       )
        ],
      ),
    );
  }
}
