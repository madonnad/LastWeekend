import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/timeline_comps/timeline_update_modal.dart';

class EditTimelineButton extends StatelessWidget {
  final bool isOwner;
  final bool isOpen;
  const EditTimelineButton(
      {super.key, required this.isOwner, required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (isOwner && isOpen) {
          return SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => BlocProvider.value(
                  value: context.read<AlbumFrameCubit>(),
                  child: BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
                    builder: (context, state) {
                      return TimelineUpdateModal(
                        album: state.album,
                        isLoading: state.loading,
                      );
                    },
                  ),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Edit Timeline"),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
