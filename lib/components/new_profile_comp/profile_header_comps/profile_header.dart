import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_header_details.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        double devWidth = MediaQuery.of(context).size.width;
        double circleDiameter = devWidth * .11;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56,
                  width: 24,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                    radius: circleDiameter,
                    backgroundColor: Colors.grey,
                    backgroundImage: const AssetImage("lib/assets/default.png"),
                    foregroundImage: NetworkImage(
                      state.user.avatarUrl,
                      headers: state.user.headers,
                    ),
                    onForegroundImageError: (_, __) {},
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 56,
                  child: GestureDetector(
                    onTap: () {
                      Map<String, dynamic> argMap = {
                        'profileBloc': context.read<ProfileBloc>(),
                      };
                      Navigator.of(context)
                          .pushNamed('/settings', arguments: argMap);
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, right: 35, left: 35, bottom: 10),
              child: FittedBox(
                child: Text(
                  state.user.fullName,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const ProfileHeaderDetail(),
          ],
        );
      },
    );
  }
}
