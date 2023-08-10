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
        color: const Color.fromRGBO(217, 217, 217, .25),
        child: SizedBox(
          height: 45,
          width: 309,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      child: Text(
                        dateText,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45),
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
                          dateCallback(DateTime.now());
                        }
                      },
                    ),
                    TextButton(
                      child: Text(
                        timeText,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45),
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
                          timeCallback(TimeOfDay.now());
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
