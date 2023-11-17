import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/feed_comp/dashboard/create_album_component.dart';
import 'package:shared_photo/components/feed_comp/dashboard/list_album_component.dart';

class DashActiveAlbums extends StatelessWidget {
  const DashActiveAlbums({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 5),
              child: Text(
                "ACTIVE ALBUMS",
                style: GoogleFonts.josefinSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: const Color.fromRGBO(213, 213, 213, 1),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: state.activeAlbums.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const CreateAlbumComponent();
                  }
                  return ListAlbumComponent(
                    index: index - 1,
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 10,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
