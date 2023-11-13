import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/feed_comp/create_album_component.dart';
import 'package:shared_photo/components/feed_comp/dash_active_album.dart';
import 'package:shared_photo/components/feed_comp/dash_greeting.dart';
import 'package:shared_photo/components/feed_comp/list_album_component.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashGreeting(),
        const Expanded(
          flex: 5,
          child: DashActiveAlbums(),
        ),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                child: Text(
                  "NOTIFICATIONS",
                  style: GoogleFonts.josefinSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: const Color.fromRGBO(213, 213, 213, 1),
                  ),
                ),
              ),
              const Expanded(
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
    );
  }
}
