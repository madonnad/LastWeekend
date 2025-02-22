import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/models/album.dart';

class RevealCountdown extends StatefulWidget {
  final Album album;
  const RevealCountdown({super.key, required this.album});

  @override
  State<RevealCountdown> createState() => _RevealCountdownState();
}

class _RevealCountdownState extends State<RevealCountdown> {
  late Timer _timer;
  Duration timeLeft = Duration();

  @override
  void initState() {
    super.initState();

    calculateTimeUntilReveal();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      calculateTimeUntilReveal();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void calculateTimeUntilReveal() {
    DateTime currentDateTime = DateTime.now();

    if (widget.album.revealDateTime.year == 1900) {
      setState(() {
        timeLeft = Duration.zero;
      });
      return;
    }

    setState(() {
      timeLeft = widget.album.revealDateTime.difference(currentDateTime);
    });
  }

  String revealsInString() {
    String days = timeLeft.inDays < 10
        ? "0${timeLeft.inDays}"
        : timeLeft.inDays.toString();
    int hoursInt = timeLeft.inHours - (timeLeft.inDays * 24);
    String hours = hoursInt < 10 ? "0$hoursInt" : hoursInt.toString();
    int minInt = timeLeft.inMinutes - (timeLeft.inHours * 60);
    String min = minInt < 10 ? "0$minInt" : minInt.toString();
    int secsInt = timeLeft.inSeconds - (timeLeft.inMinutes * 60);
    String secs = secsInt < 10 ? "0$secsInt" : secsInt.toString();

    return "$days:$hours:$min:$secs";
  }

  @override
  Widget build(BuildContext context) {
    calculateTimeUntilReveal();
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 98, 96, .5),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Color.fromRGBO(255, 98, 96, 1),
          )),
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      margin: const EdgeInsets.only(bottom: 4.0, left: 2.0, right: 2.0),
      child: Builder(
        builder: (context) {
          if (widget.album.phase == AlbumPhases.open) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Reveals in",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    revealsInString(),
                    style: GoogleFonts.dmMono(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            );
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Revealed on",
                  style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.album.revealDateTimeFormatter,
                  style: GoogleFonts.josefinSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
