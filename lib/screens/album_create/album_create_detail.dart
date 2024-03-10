import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/album_cover_select.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/album_title_field.dart';

import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/create_album_comp/create_album_friend_comp/add_friends_info_list.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/create_album_button.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/date_time_section.dart';

class AlbumCreateDetail extends StatelessWidget {
  final PageController createAlbumController;

  const AlbumCreateDetail({Key? key, required this.createAlbumController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateAlbumCubit, CreateAlbumState>(
      listener: (context, state) {
        if (state.exception != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.exception?.errorMessage ?? "Error")));
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.black,
          padding: EdgeInsets.only(
            top: kToolbarHeight,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const AlbumTitleField(),
                  const Expanded(
                    child: Align(
                      child: AlbumCoverSelect(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 8),
                    child: SectionHeaderSmall('Duration'),
                  ),
                  const DateTimeSection(),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: SectionHeaderSmall('Friends'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: AddFriendsInfoList(
                      pageController: createAlbumController,
                    ),
                  ),
                  BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
                    builder: (context, state) {
                      return Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: state.canCreate
                              ? () => context
                                      .read<CreateAlbumCubit>()
                                      .createAlbum()
                                      .then((success) {
                                    if (success) {
                                      Navigator.of(context).pop();
                                    }
                                  })
                              : null,
                          child: const CreateAlbumButton(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              state.loading
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        );
      },
    );
  }
}
