import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/album_cover_select.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/album_title_field.dart';

import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/create_album_button.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/visibility_toggle_switch.dart';
import 'package:shared_photo/components/create_event_comp/create_event_friend_page/add_friends_info_list.dart';

class AlbumCreateDetail extends StatelessWidget {
  final PageController createAlbumController;

  const AlbumCreateDetail({super.key, required this.createAlbumController});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateEventCubit, CreateEventState>(
      listenWhen: (previous, current) => current.exception.errorString != null,
      listener: (context, state) {
        String errorString = "${state.exception.errorString} ";
        SnackBar snackBar = SnackBar(
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          content: Text(errorString),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    padding: EdgeInsets.only(top: 10.0, bottom: 0),
                    child: SectionHeaderSmall('Duration'),
                  ),
                  // const DateTimeSection(),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 8),
                    child: SectionHeaderSmall('Visibility'),
                  ),
                  const VisibilityToggleSwitch(),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 8),
                    child: SectionHeaderSmall('Friends'),
                  ),
                  AddFriendsInfoList(
                    pageController: createAlbumController,
                  ),
                  const Gap(25),
                  BlocBuilder<CreateEventCubit, CreateEventState>(
                    builder: (context, state) {
                      return Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: state.canCreate
                              ? () => context
                                      .read<CreateEventCubit>()
                                      .createEvent()
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
