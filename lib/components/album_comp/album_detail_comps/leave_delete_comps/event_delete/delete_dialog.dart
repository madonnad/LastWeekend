import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus?.unfocus(),
            decoration: InputDecoration(hintText: "delete"),
          ),
        ),
        Center(
          child: SimpleDialogOption(
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Leave"),
            ),
          ),
        )
      ],
    );
  }
}
