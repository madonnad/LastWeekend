import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/components/feed_comp/dashboard/create_album_component.dart';
import 'package:shared_photo/components/feed_comp/dashboard/dash_active_album.dart';
import 'package:shared_photo/components/feed_comp/dashboard/dash_greeting.dart';
import 'package:shared_photo/components/feed_comp/dashboard/list_album_component.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: StandardLogo(),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 45, 15, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashGreeting(),
                Expanded(
                  flex: 5,
                  child: AlbumHorizontalListView(),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 25.0, bottom: 5),
                        child: SectionHeaderSmall("notifications"),
                      ),
                      Expanded(
                        child: Card(
                          color: Color.fromRGBO(19, 19, 19, 1),
                          child: SizedBox(
                            width: 375,
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
