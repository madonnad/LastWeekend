import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/new_profile_comp/event_section/profile_event_item.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileHeader(),
                      //TopFriendsComponent(),
                      //SizedBox(height: 25),
                      //MonthlyRecapList(),
                      //const ProfileRevealedAlbums(),
                      Gap(25),
                      ProfileEventItem(
                        event: context.read<ProfileBloc>().state.myAlbums[0],
                        headers: context.read<ProfileBloc>().user.headers,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 35,
                  color: Colors.black,
                  child: PageView.builder(
                    controller: PageController(
                      initialPage: 0,
                      viewportFraction: 0.4,
                    ),
                    itemCount: state.myEventsByDatetime.length,
                    itemBuilder: (context, index) {
                      // if (index == 0) {
                      //   return Icon(
                      //     Icons.favorite,
                      //     color: Colors.white,
                      //   );
                      // }

                      String text;
                      DateTime dt =
                          state.myEventsByDatetime.keys.toList()[index];
                      if (dt.year == DateTime.now().year) {
                        text = DateFormat("MMMM").format(
                            state.myEventsByDatetime.keys.toList()[index]);
                      } else {
                        text = DateFormat("MMM yyyy").format(
                            state.myEventsByDatetime.keys.toList()[index]);
                      }

                      return Center(
                        child: Text(
                          text,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
