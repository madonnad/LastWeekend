import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';

class DashGreeting extends StatefulWidget {
  const DashGreeting({super.key});

  @override
  State<DashGreeting> createState() => _DashGreetingState();
}

class _DashGreetingState extends State<DashGreeting> {
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    child: Text(
                      greetingString,
                      style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 2,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          tileMode: TileMode.mirror,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
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
                        state.user.fullName,
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(
                  flex: 1,
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
