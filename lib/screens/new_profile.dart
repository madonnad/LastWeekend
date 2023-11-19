import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/custom_profile_picture.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_detail_element.dart';

class NewProfileScreen extends StatelessWidget {
  const NewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        String numOfFriends =
            context.read<ProfileBloc>().state.myFriends.length.toString();
        String numOfAlbums =
            context.read<ProfileBloc>().state.myAlbums.length.toString();
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  Column(
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
                      Row(
                        children: [
                          const Spacer(flex: 3),
                          Expanded(
                            flex: 2,
                            child: ProfileDetailElement(
                              title: "friends",
                              value: numOfFriends,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ProfileDetailElement(
                              title: "albums",
                              value: numOfAlbums,
                            ),
                          ),
                          const Spacer(flex: 3),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
