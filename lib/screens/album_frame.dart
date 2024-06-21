import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/dashboard_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/invite_comps/invite_page.dart';
import 'package:shared_photo/components/album_comp/lock_comps/album_lock_tab_view.dart';
import 'package:shared_photo/components/album_comp/util_comps/album_appbar_title.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/album_reveal_tab_view.dart';
import 'package:shared_photo/components/album_comp/unlock_comps/album_unlock_tab_view.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/image_frame.dart';

final List<String> filterList = ["Popular", "Guests", "Timeline"];

class AlbumFrame extends StatelessWidget {
  final Arguments arguments;

  const AlbumFrame({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AlbumAppBarTitle(),
      body: BlocListener<AlbumFrameCubit, AlbumFrameState>(
        listenWhen: (previous, current) =>
            previous.album.albumId != current.album.albumId ||
            previous.album.images != current.album.images,
        listener: (context, state) {
          pushImageFrameIfPassed(context, arguments);
        },
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 7) {
              Navigator.of(context).pop();
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Invite",
                          style: GoogleFonts.josefinSans(
                            color: state.album.phase == AlbumPhases.invite
                                ? Colors.white
                                : const Color.fromRGBO(125, 125, 125, 1),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Unlock",
                          style: GoogleFonts.josefinSans(
                            color: state.album.phase == AlbumPhases.unlock
                                ? Colors.white
                                : const Color.fromRGBO(125, 125, 125, 1),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Lock",
                          style: GoogleFonts.josefinSans(
                            color: state.album.phase == AlbumPhases.lock
                                ? Colors.white
                                : const Color.fromRGBO(125, 125, 125, 1),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Reveal",
                          style: GoogleFonts.josefinSans(
                            color: state.album.phase == AlbumPhases.reveal
                                ? Colors.white
                                : const Color.fromRGBO(125, 125, 125, 1),
                            fontSize: 16,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                builder: (context, state) {
                  switch (state.album.phase) {
                    case AlbumPhases.reveal:
                      return AlbumRevealTabView(arguments: arguments);
                    case AlbumPhases.invite:
                      return const InvitePage();
                    case AlbumPhases.unlock:
                      return const AlbumUnlockTabView();
                    case AlbumPhases.lock:
                      return const AlbumLockTabView();
                    default:
                      return const Placeholder();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void pushImageFrameIfPassed(BuildContext context, Arguments arguments) {
  if (arguments.imageID != null) {
    int selectedIndex = context
        .read<AlbumFrameCubit>()
        .state
        .imageFrameTimelineList
        .indexWhere((element) => element.imageId == arguments.imageID);

    arguments.imageID = null;

    context
        .read<AlbumFrameCubit>()
        .initalizeImageFrameWithSelectedImage(selectedIndex);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<AlbumFrameCubit>(),
          ),
          BlocProvider(
            create: (context) => ImageFrameCubit(
              dataRepository: context.read<DataRepository>(),
              user: context.read<AppBloc>().state.user,
              image: context
                  .read<AlbumFrameCubit>()
                  .state
                  .imageFrameTimelineList[selectedIndex],
              albumID: arguments.albumID,
            ),
          ),
        ],
        child: const ImageFrame(),
      ),
    );
  }
}
