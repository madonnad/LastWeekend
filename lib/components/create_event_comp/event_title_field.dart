import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class EventTitleField extends StatelessWidget {
  const EventTitleField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return Expanded(
          child: Container(
            height: 220,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
              border: Border.all(
                color: Color.fromRGBO(242, 243, 247, .5),
              ),
            ),
            child: TextField(
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              //cursorHeight: 18,
              onChanged: (text) =>
                  context.read<CreateEventCubit>().setEventTitle(text),
              controller: state.albumName,
              textAlignVertical: TextAlignVertical.center,
              maxLines: null,
              minLines: 6,
              maxLength: 50,
              style: GoogleFonts.lato(
                color: Color.fromRGBO(242, 243, 247, 1),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: "Event Name",
                hintStyle: GoogleFonts.lato(
                  color: Color.fromRGBO(242, 243, 247, .3),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                focusedBorder: InputBorder.none,
                counterStyle: GoogleFonts.montserrat(
                  color: Color.fromRGBO(242, 243, 247, 1),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        );
      },
    );
  }
}
