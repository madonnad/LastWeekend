import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';

class DeleteDialog extends StatefulWidget {
  const DeleteDialog({super.key});

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  bool confirmed = false;

  void checkText(String text) {
    if (text == 'delete') {
      setState(() {
        confirmed = true;
      });
    } else {
      setState(() {
        confirmed = false;
      });
    }
  }

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
                  "Delete event?",
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
                    "Are you sure you want to delete the event?\n \nAll images will be permanently deleted and not recoverable.\n \nTo confirm type ‘delete’ in the box below:",
                    style: GoogleFonts.lato(
                        color: Color.fromRGBO(242, 243, 247, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),
                ),
                SimpleDialogOption(
                  child: TextField(
                    onChanged: (text) => checkText(text),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(hintText: "delete"),
                  ),
                ),
                Center(
                  child: SimpleDialogOption(
                    child: ElevatedButton(
                      onPressed: confirmed
                          ? () => context
                                  .read<AlbumFrameCubit>()
                                  .deleteEvent()
                                  .then((success) {
                                if (success && context.mounted) {
                                  Navigator.of(context)
                                      .popUntil(ModalRoute.withName('/'));
                                }
                              })
                          : null,
                      child: Text("Delete"),
                    ),
                  ),
                )
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
