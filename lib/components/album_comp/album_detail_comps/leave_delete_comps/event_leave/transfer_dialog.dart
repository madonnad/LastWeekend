import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/guest.dart';

class TransferDialog extends StatefulWidget {
  const TransferDialog({super.key});

  @override
  State<TransferDialog> createState() => _TransferDialogState();
}

class _TransferDialogState extends State<TransferDialog> {
  double oneHeight = 250;
  double twoHeight = 350;
  late double height;
  bool canLeave = false;

  @override
  void initState() {
    super.initState();
    height = oneHeight;
  }

  void updateDialog() {}

  @override
  Widget build(BuildContext context) {
    String userID = context.read<AppBloc>().state.user.id;
    return BlocBuilder<AlbumFrameCubit, AlbumFrameState>(
      builder: (context, state) {
        return LayoutBuilder(builder: (context, constraints) {
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
            //contentPadding: EdgeInsets.only(top: 12),
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 250),
                height: height,
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    SimpleDialogOption(
                      child: Text(
                        "You’ll need to transfer ownership of this album before you can leave.\n \nSelect the new owner below:",
                        style: GoogleFonts.lato(
                          color: Color.fromRGBO(242, 243, 247, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    DropdownMenu<Guest>(
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: Color.fromRGBO(56, 56, 60, 1),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      expandedInsets: EdgeInsets.symmetric(horizontal: 24),
                      initialSelection: state.album.guests
                          .firstWhere((guest) => guest.uid == userID),
                      onSelected: (value) {
                        if (value?.uid == userID) {
                          setState(() {
                            canLeave = false;
                            height = oneHeight;
                          });
                        } else {
                          setState(() {
                            canLeave = true;
                            height = twoHeight;
                          });
                        }
                      },
                      dropdownMenuEntries: state.album.guests.map(
                        (Guest guest) {
                          bool isOwner = guest.uid == userID;
                          return DropdownMenuEntry(
                            value: guest,
                            label: guest.fullName,
                            enabled: !isOwner,
                          );
                        },
                      ).toList(),
                    ),
                    Gap(10),
                    canLeave
                        ? Expanded(
                            child: SimpleDialogOption(
                              child: Text(
                                "Are you sure you want to leave the event?\n \nYou’ll no longer be able to see images you have added to this event.",
                                style: GoogleFonts.lato(
                                  color: Color.fromRGBO(242, 243, 247, 1),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    canLeave ? SizedBox.shrink() : Spacer(),
                    Center(
                      child: SimpleDialogOption(
                        child: ElevatedButton(
                          onPressed: canLeave ? () {} : null,
                          child: Text("Leave event"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }
}
