import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/cover_photo_detail.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/leave_delete_comps/delete_leave_event_button.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/visibility_comps/edit_visibility_button.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invite_list_button.dart';
import 'package:shared_photo/models/notification.dart';

class AlbumDetailFrame extends StatelessWidget {
  const AlbumDetailFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        bool isOwner =
            context.read<AppBloc>().state.user.id == state.album.albumOwner;
        bool hasImages = state.album.images.isNotEmpty;
        bool hasGuests = state.album.guests
                .where((element) => element.status == RequestStatus.accepted)
                .length >
            1;
        return Scaffold(
          //backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
            ),
            title: Text(state.album.albumName, style: TextStyle(fontSize: 20)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Gap(45),
                CoverPhotoDetail(),
                const Gap(60),
                InviteListButton(),
                const Gap(10),
                EditVisibilityButton(isOwner: isOwner),
                const Gap(10),
                DeleteLeaveEventButton(
                  isOwner: isOwner,
                  hasImages: hasImages,
                  hasGuests: hasGuests,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
