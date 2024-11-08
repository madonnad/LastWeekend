import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class EventTitleField extends StatelessWidget {
  const EventTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            height: 220,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
              border: Border.all(
                color: Colors.white54,
              ),
            ),
            child: TextField(
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              //cursorHeight: 18,
              controller: state.albumName,
              textAlignVertical: TextAlignVertical.center,
              maxLines: null,
              minLines: 6,
              maxLength: 50,
              style: GoogleFonts.josefinSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: "Event Name",
                hintStyle: GoogleFonts.josefinSans(
                  color: Colors.white30,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                focusedBorder: InputBorder.none,
                counterStyle: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
