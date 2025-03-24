import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/album_frame_cubit.dart';
import 'package:shared_photo/models/album.dart';

class TimelineUpdateModal extends StatefulWidget {
  final Album album;
  final bool isLoading;
  const TimelineUpdateModal(
      {super.key, required this.album, required this.isLoading});

  @override
  State<TimelineUpdateModal> createState() => _TimelineUpdateModalState();
}

class _TimelineUpdateModalState extends State<TimelineUpdateModal> {
  bool canUpdate = false;
  bool showSelector = true;
  late DateTime newDatetime;
  late DateTime minDateTime;

  @override
  void initState() {
    newDatetime = widget.album.revealDateTime;

    if (widget.album.revealDateTime
        .isAfter(DateTime.now().add(Duration(minutes: 30)))) {
      minDateTime = DateTime.now().add(Duration(minutes: 30));
    } else if (widget.album.revealDateTime
        .isBefore(DateTime.now().subtract(Duration(seconds: 30)))) {
      showSelector = false;
    } else {
      minDateTime = widget.album.revealDateTime.toLocal();
    }

    super.initState();
  }

  void updateDatetime(DateTime datetime) {
    if (datetime == widget.album.revealDateTime) {
      setState(() {
        canUpdate = false;
        newDatetime = datetime;
      });
    } else {
      setState(() {
        canUpdate = true;
        newDatetime = datetime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SimpleDialog(
          title: Center(child: Text("Timeline")),
          titleTextStyle: GoogleFonts.lato(
            color: Color.fromRGBO(242, 243, 247, .75),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          contentPadding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 16.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 24.0),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reveal Time",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap(50),
                  Text(
                    widget.album.revealDateTimeFormatter,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Builder(builder: (context) {
              if (showSelector) {
                return Column(
                  children: [
                    SimpleDialogOption(
                      child: SizedBox(
                        height: 150,
                        width: 100000,
                        child: CupertinoDatePicker(
                          onDateTimeChanged: (datetime) =>
                              updateDatetime(datetime),
                          initialDateTime:
                              widget.album.revealDateTime.toLocal(),
                          minimumDate:
                              minDateTime, //widget.album.creationDateTime.toLocal(),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 75),
                      child: ElevatedButton(
                        onPressed: canUpdate
                            ? () => context
                                .read<AlbumFrameCubit>()
                                .updateDatetime(newDatetime)
                            : null,
                        child: Text("Update"),
                      ),
                    ),
                  ],
                );
              } else {
                return SimpleDialogOption(
                  child: Center(
                      child: Text("Events Already Revealed - Cannot Reopen")),
                );
              }
            }),
          ],
        ),
        widget.isLoading
            ? Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
