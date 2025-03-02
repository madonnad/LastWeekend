import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/visibility_comps/visibility_select_modal.dart';

class EditVisibilityButton extends StatelessWidget {
  final bool isOwner;
  const EditVisibilityButton({super.key, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if (isOwner) {
          return SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => BlocProvider.value(
                  value: context.read<AlbumFrameCubit>(),
                  child: const VisibilitySelectModal(),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Edit Visibility"),
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
