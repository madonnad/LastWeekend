import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/reveal_comps/reveal_event_landing.dart';
import 'package:shared_photo/components/album_comp/util_comps/album_appbar_title.dart';
import 'package:shared_photo/components/album_comp/unlock_comps/album_unlock_tab_view.dart';
import 'package:shared_photo/components/album_comp/util_comps/reveal_countdown.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/models/photo.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/new_image_frame.dart';

final List<String> filterList = ["Popular", "Guests", "Timeline"];

class EventFrame extends StatelessWidget {
  final Arguments arguments;

  const EventFrame({super.key, required this.arguments});

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
              BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                builder: (context, state) {
                  return RevealCountdown(
                    album: state.album,
                  );
                },
              ),
              BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                builder: (context, state) {
                  switch (state.album.phase) {
                    case AlbumPhases.reveal:
                      return RevealEventLanding();
                    case AlbumPhases.open:
                      return const AlbumUnlockTabView();
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
    Photo selectedImage = context
        .read<AlbumFrameCubit>()
        .state
        .imageFrameTimelineList
        .firstWhere((element) => element.imageId == arguments.imageID);

    arguments.imageID = null;

    context
        .read<AlbumFrameCubit>()
        .initalizeImageFrameWithSelectedImage(selectedImage);

    Photo? photo = context.read<AlbumFrameCubit>().state.selectedImage;
    int index = photo != null
        ? context
            .read<AlbumFrameCubit>()
            .state
            .imageFrameTimelineList
            .indexOf(photo)
        : 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      enableDrag: false,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<AlbumFrameCubit>(),
          ),
          BlocProvider(
            create: (context) => ImageFrameCubit(
              dataRepository: context.read<DataRepository>(),
              user: context.read<AppBloc>().state.user,
              image: selectedImage,
              albumID: arguments.albumID,
            ),
          ),
        ],
        child: NewImageFrame(
          index: index,
        ),
      ),
    );
  }
}
