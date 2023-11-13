import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';

class DashGreeting extends StatelessWidget {
  const DashGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    String fullName = context.read<AppBloc>().state.user.fullName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: FittedBox(
                child: Text(
                  'Happy Weekend,',
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
                    fullName,
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
  }
}
