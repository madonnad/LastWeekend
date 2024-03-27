import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/friend_profile_cubit.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_detail_element.dart';

class FriendProfileHeader extends StatelessWidget {
  const FriendProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double circleDiameter = devWidth * .2;
    return BlocBuilder<FriendProfileCubit, FriendProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            CircleAvatar(
              radius: circleDiameter,
              backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
              backgroundImage: const AssetImage("lib/assets/default.png"),
              foregroundImage: NetworkImage(
                state.anonymousFriend.imageReq,
                headers: context.read<AppBloc>().state.user.headers,
              ),
              onForegroundImageError: (_, __) {},
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 35, left: 35, bottom: 5),
              child: FittedBox(
                child: Text(
                  "${state.anonymousFriend.firstName} ${state.anonymousFriend.lastName}",
                  style: GoogleFonts.josefinSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileDetailElement(
                    title: "friends",
                    value: state.anonymousFriend.numberOfFriends.toString()),
                const SizedBox(width: 45),
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
