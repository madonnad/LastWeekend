import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/leave_delete_comps/event_delete/delete_dialog.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/leave_delete_comps/event_leave/leave_dialog.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/leave_delete_comps/event_leave/transfer_dialog.dart';

class DeleteLeaveEventButton extends StatelessWidget {
  final bool isOwner;
  final bool hasImages;
  final bool hasGuests;
  const DeleteLeaveEventButton({
    super.key,
    required this.isOwner,
    required this.hasImages,
    required this.hasGuests,
  });

  @override
  Widget build(BuildContext context) {
    if ((isOwner && !hasImages) || (isOwner && !hasGuests)) {
      return ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return DeleteDialog();
          },
        ),
        child: Text("Delete Event"),
      );
    } else if (isOwner) {
      return ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => BlocProvider.value(
            value: context.read<AlbumFrameCubit>(),
            child: const TransferDialog(),
          ),
        ),
        child: Text("Leave Event"),
      );
    } else {
      return ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => BlocProvider.value(
            value: context.read<AlbumFrameCubit>(),
            child: const LeaveDialog(),
          ),
        ),
        child: Text("Leave Event"),
      );
    }
  }
}
