import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaveDialog extends StatelessWidget {
  const LeaveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
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
              onPressed: () {},
              child: Text("Leave Event"),
            ),
          ),
        )
      ],
    );
  }
}
