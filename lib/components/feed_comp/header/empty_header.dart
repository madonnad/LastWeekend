import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';

class EmptyHeader extends StatefulWidget {
  const EmptyHeader({super.key});

  @override
  State<EmptyHeader> createState() => _EmptyHeaderState();
}

class _EmptyHeaderState extends State<EmptyHeader> {
  String greetingString = 'Happy Weekend,';

  @override
  void initState() {
    DateTime now = DateTime.now();
    switch (now.weekday) {
      case 1:
        greetingString = 'Happy Monday,';
      case 2:
        greetingString = 'Happy Tuesday,';
      case 3:
        greetingString = 'Happy Wednesday,';
      case 4:
        greetingString = 'Happy Thursday,';
      case 5:
        greetingString = 'Happy Friday,';
      case 6:
        greetingString = 'Happy Weekend,';
      case 7:
        greetingString = 'Happy Weekend,';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "$greetingString ${state.user.firstName}",
                  style: GoogleFonts.josefinSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              ),
              Text(
                "You have no open events right now.",
                style: GoogleFonts.montserrat(
                  color: Color.fromRGBO(218, 218, 218, .5),
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
