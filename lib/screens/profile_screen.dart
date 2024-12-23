import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/new_profile_comp/event_section/event_viewer.dart';
import 'package:shared_photo/components/new_profile_comp/event_section/month_page_view.dart';
import 'package:shared_photo/components/new_profile_comp/event_section/profile_event_item.dart';
import 'package:shared_photo/components/new_profile_comp/profile_header_comps/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> selectedPageNotifier = ValueNotifier<String>('');

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        print(state.myAlbumsMap);
      },
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
                      Gap(25),
                      state.myEventsByDatetime.isNotEmpty
                          ? EventViewer(
                              eventMap: state.myEventsByDatetime,
                              selectedPageNotifier: selectedPageNotifier,
                            )
                          : SizedBox(
                              height: 400,
                              child: Center(
                                child: Text(
                                  "No Events",
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white54,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: MonthPageView(
                  selectedPageNotifier: selectedPageNotifier,
                  monthList: state.myEventsByDatetime.keys.toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
