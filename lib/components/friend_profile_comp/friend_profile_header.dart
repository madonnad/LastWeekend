import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/components/friend_profile_comp/friend_status_logic.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_detail_element.dart';

class FriendProfileHeader extends StatelessWidget {
  const FriendProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double circleDiameter = devWidth * .11;
    return BlocBuilder<FriendProfileCubit, FriendProfileState>(
      builder: (context, state) {
        CachedNetworkImageProvider.defaultCacheManager.emptyCache();
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                    radius: circleDiameter,
                    backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                    backgroundImage: const AssetImage("lib/assets/default.png"),
                    foregroundImage: CachedNetworkImageProvider(
                      state.anonymousFriend.imageReq540,
                      headers: context.read<AppBloc>().state.user.headers,
                    ),
                    onForegroundImageError: (_, __) {},
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 56,
                  width: 24,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, right: 35, left: 35, bottom: 10),
              child: FittedBox(
                child: Text(
                  "${state.anonymousFriend.firstName} ${state.anonymousFriend.lastName}",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FriendStatusLogic(),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileDetailElement(
                    title: "friends",
                    value: state.anonymousFriend.numberOfFriends.toString()),
                const SizedBox(width: 10),
                ProfileDetailElement(
                  title: "albums",
                  value: state.anonymousFriend.numberOfAlbums.toString(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
