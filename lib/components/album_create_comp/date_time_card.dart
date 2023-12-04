import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateTimeCard extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime currentDate;
  final String name;
  final String dateText;
  final String timeText;
  final ValueSetter<DateTime> dateCallback;
  final ValueSetter<TimeOfDay> timeCallback;

  const DateTimeCard({
    required this.name,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.currentDate,
    required this.dateText,
    required this.timeText,
    required this.dateCallback,
    required this.timeCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        elevation: 0,
        color: const Color.fromRGBO(217, 217, 217, 1),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: const BoxDecoration(color: Color.fromRGBO(19, 19, 19, 1)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    tileMode: TileMode.mirror,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(255, 205, 178, 1),
                      Color.fromRGBO(255, 180, 162, 1),
                      Color.fromRGBO(229, 152, 155, 1),
                      Color.fromRGBO(181, 131, 141, 1),
                      Color.fromRGBO(109, 104, 117, 1),
                    ],
                  ).createShader(bounds);
                },
                child: Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    child: Text(
                      dateText,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: firstDate,
                        lastDate: lastDate,
                        currentDate: currentDate,
                      );
                      if (pickedDate != null) {
                        dateCallback(pickedDate);
                      } else {
                        null;
                      }
                    },
                  ),
                  TextButton(
                    child: Text(
                      timeText,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      TimeOfDay? timePicked = await showTimePicker(
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (timePicked != null) {
                        timeCallback(timePicked);
                      } else {
                        null;
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
