import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class RevealDurationRow extends StatelessWidget {
  const RevealDurationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Event reveals at",
                style: GoogleFonts.lato(
                  color: Colors.white54,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${state.revealDateString!} • ${state.revealTimeString} ",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
