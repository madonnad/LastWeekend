import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/notification.dart';

class CurrentInviteList extends StatelessWidget {
  const CurrentInviteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
          builder: (context, state) {
            return Stack(
              children: [
                ListView.builder(
                  itemCount: state.album.sortedGuestsByInvite.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    const Color.fromRGBO(16, 16, 16, 1),
                                backgroundImage:
                                    AssetImage("lib/assets/placeholder.png"),
                                foregroundImage: CachedNetworkImageProvider(
                                  state.album.sortedGuestsByInvite[index]
                                      .avatarReq540,
                                  headers: context
                                      .read<AppBloc>()
                                      .state
                                      .user
                                      .headers,
                                  errorListener: (_) {},
                                ),
                                radius: 18,
                                onForegroundImageError: (_, __) {},
                              ),
                              const Gap(15),
                              Text(
                                state
                                    .album.sortedGuestsByInvite[index].fullName,
                                style: GoogleFonts.josefinSans(
                                  color: state.album.sortedGuestsByInvite[index]
                                              .status ==
                                          RequestStatus.accepted
                                      ? Colors.white
                                      : const Color.fromRGBO(125, 125, 125, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          switch (
                              state.album.sortedGuestsByInvite[index].status) {
                            RequestStatus.accepted => const Icon(
                                Icons.check_circle,
                                color: Colors.green),
                            RequestStatus.pending => const Icon(
                                Icons.help_outline_outlined,
                                color: Color.fromRGBO(125, 125, 125, 1)),
                            RequestStatus.denied =>
                              const Icon(Icons.cancel, color: Colors.red),
                            RequestStatus.abandoned => Text(
                                "has left",
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(125, 125, 125, 1),
                                ),
                              )
                          }
                        ],
                      ),
                    );
                  },
                ),
                state.loading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox(height: 0),
              ],
            );
          },
        ),
      ),
    );
  }
}
