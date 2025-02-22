import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientCountdownTimer extends StatefulWidget {
  final DateTime revealDateTime;
  const GradientCountdownTimer({super.key, required this.revealDateTime});

  @override
  State<GradientCountdownTimer> createState() => _GradientCountdownTimerState();
}

class _GradientCountdownTimerState extends State<GradientCountdownTimer> {
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

    if (widget.revealDateTime.year == 1900) {
      setState(() {
        timeLeft = Duration.zero;
      });
      return;
    }

    setState(() {
      timeLeft = widget.revealDateTime.difference(currentDateTime);
      if (timeLeft.isNegative) {
        timeLeft = Duration.zero;
      }
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
    return Text(
      revealsInString(),
      style: GoogleFonts.dmMono(
        color: Color.fromRGBO(255, 98, 96, 1),
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
    );
  }
}


// ShaderMask(
//       shaderCallback: (bounds) {
//         return const LinearGradient(
//           begin: Alignment.centerRight,
//           end: Alignment.centerLeft,
//           colors: [
//             Color.fromRGBO(255, 205, 178, 1),
//             Color.fromRGBO(255, 180, 162, 1),
//             Color.fromRGBO(229, 152, 155, 1),
//             Color.fromRGBO(181, 131, 141, 1),
//             Color.fromRGBO(109, 104, 117, 1),
//           ],
//         ).createShader(bounds);
//       },
//       child: Text(
//         revealsInString(),
//         style: GoogleFonts.dmMono(
//           color: Colors.white,
//           fontWeight: FontWeight.w400,
//           fontSize: 15,
//         ),
//       ),
//     );