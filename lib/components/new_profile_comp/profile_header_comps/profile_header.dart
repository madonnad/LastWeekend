import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_header_details.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        double devWidth = MediaQuery.of(context).size.width;
        double circleDiameter = devWidth * .25;
        return Column(
          children: [
            CircleAvatar(
              radius: circleDiameter,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage("lib/assets/default.png"),
              foregroundImage: NetworkImage(
                state.user.avatarUrl,
                headers: state.user.headers,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, right: 35, left: 35, bottom: 5),
              child: FittedBox(
                child: Text(
                  state.user.fullName,
                  style: GoogleFonts.josefinSans(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
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
