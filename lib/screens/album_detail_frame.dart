import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/cover_photo_detail.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/leave_delete_comps/delete_leave_event_button.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/timeline_comps/edit_timeline_button.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/visibility_comps/edit_visibility_button.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invite_list_button.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/notification.dart';

class AlbumDetailFrame extends StatelessWidget {
  const AlbumDetailFrame({super.key});

  @override
  Widget build(BuildContext context) {
    String userID = context.read<AppBloc>().state.user.id;
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        bool isOwner = userID == state.album.albumOwner;
        bool hasImages = state.album.imageMap.isNotEmpty;
        bool hasGuests = state.album.guests
                .where((element) => element.status == RequestStatus.accepted)
                .length >
            1;
        bool activeInAlbum = state.album.guests.any((element) =>
            element.uid == userID && element.status == RequestStatus.accepted);
        bool albumOpen = state.album.phase == AlbumPhases.open;
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
                const Gap(30),
                CoverPhotoDetail(),
                const Gap(30),
                InviteListButton(activeInAlbum: activeInAlbum),
                Builder(
                  builder: (context) {
                    if (activeInAlbum) {
                      return Column(
                        children: [
                          const Gap(8),
                          EditVisibilityButton(isOwner: isOwner),
                          const Gap(8),
                          EditTimelineButton(
                            isOwner: isOwner,
                            isOpen: albumOpen,
                          ),
                          const Gap(8),
                          DeleteLeaveEventButton(
                            isOwner: isOwner,
                            hasImages: hasImages,
                            hasGuests: hasGuests,
                          ),
                        ],
                      );
                    } else {
                      return SizedBox(
                        width: double.infinity,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
