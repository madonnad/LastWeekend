import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/cubit/create_album_cubit.dart';

class AlbumTitleField extends StatelessWidget {
  const AlbumTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return TextField(
          onTapOutside: (event) =>
              FocusManager.instance.primaryFocus?.unfocus(),
          controller: state.albumName,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 24,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "enter album name",
            hintStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 24,
              color: Colors.white54,
            ),
          ),
        );
      },
    );
  }
}
