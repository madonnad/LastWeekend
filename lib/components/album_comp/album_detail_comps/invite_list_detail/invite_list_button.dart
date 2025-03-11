import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/components/album_comp/album_detail_comps/invite_list_detail/invite_list_main.dart';

class InviteListButton extends StatelessWidget {
  final bool activeInAlbum;
  const InviteListButton({super.key, required this.activeInAlbum});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          //backgroundColor: Colors.black,
          builder: (ctx) {
            return BlocProvider.value(
              value: context.read<AlbumFrameCubit>(),
              child: InviteListMain(activeInAlbum: activeInAlbum),
            );
          },
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("Invite List"),
        ),
      ),
    );
  }
}
