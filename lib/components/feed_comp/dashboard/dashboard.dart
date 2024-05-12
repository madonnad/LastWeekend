import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/dashboard_bloc.dart';

import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/components/feed_comp/dashboard/dash_active_album.dart';
import 'package:shared_photo/components/feed_comp/dashboard/dash_greeting.dart';
import 'package:shared_photo/components/feed_comp/dashboard/empty_active_album_section.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: StandardLogo(
            fontSize: 30,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 45, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DashGreeting(),
                Expanded(
                  flex: 5,
                  child: BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      if (state.activeAlbums.isEmpty) {
                        return const EmptyActiveAlbumSection();
                      }
                      return const AlbumHorizontalListView();
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 25.0, bottom: 5),
                        child: SectionHeaderSmall("notifications"),
                      ),
                      Expanded(
                        child: Card(
                          color: const Color.fromRGBO(19, 19, 19, 1),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            child: Text(
                              'No new notifications',
                              style: GoogleFonts.josefinSans(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
