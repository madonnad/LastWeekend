import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/empty_album_unlock.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/event_guest_row.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/trending_slideshow.dart';

class RevealEventLanding extends StatelessWidget {
  const RevealEventLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        return state.images.isNotEmpty
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: ListView(
                    children: [
                      Gap(5),
                      TrendingSlideshow(
                        slideshowPhotos: state.shuffledPhotos,
                        albumID: state.album.albumId,
                      ),
                      Gap(20),
                      EventGuestRow(guestList: state.mostImagesUploaded),
                      Gap(20),
                      Container(
                        height: 850,
                        color: Colors.brown,
                      ),
                    ],
                  ),
                ),
              )
            : Expanded(
                child: EmptyAlbumView(
                  isUnlockPhase: false,
                  album: state.album,
                ),
              );
      },
    );
  }
}
