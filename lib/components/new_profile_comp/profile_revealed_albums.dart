import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/feed_comp/dashboard/horizontal_album_list.dart';

class ProfileRevealedAlbums extends StatelessWidget {
  const ProfileRevealedAlbums({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SizedBox(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 25.0, bottom: 5),
                child: SectionHeaderSmall("albums"),
              ),
              HorizontalAlbumList(
                albumList: state.revealedAlbums,
              ),
            ],
          ),
        );
      },
    );
  }
}
