import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/custom_profile_picture.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_header_details.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomProfilePicture(
              url: state.user.avatarUrl,
              headers: state.user.headers,
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
