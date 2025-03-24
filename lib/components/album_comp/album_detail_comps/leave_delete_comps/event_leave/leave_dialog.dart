import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';

class LeaveDialog extends StatelessWidget {
  const LeaveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        return Stack(
          children: [
            SimpleDialog(
              backgroundColor: Color.fromRGBO(34, 34, 38, 1),
              title: Center(
                child: Text(
                  "Leave event?",
                  style: GoogleFonts.lato(
                    color: Color.fromRGBO(242, 243, 247, .75),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              children: [
                SimpleDialogOption(
                  child: Text(
                    "Are you sure you want to leave the event?\n \nYou’ll no longer be able to see images you have added to this event.",
                    style: GoogleFonts.lato(
                        color: Color.fromRGBO(242, 243, 247, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                Center(
                  child: SimpleDialogOption(
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<AlbumFrameCubit>().leaveEvent().then(
                        (success) {
                          if (success && context.mounted) {
                            Navigator.of(context)
                                .popUntil(ModalRoute.withName('/'));
                          }
                        },
                      ),
                      child: Text("Leave Event"),
                    ),
                  ),
                ),
              ],
            ),
            state.loading
                ? Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
