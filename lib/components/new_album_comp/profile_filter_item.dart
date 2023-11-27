import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/new_album_frame_cubit.dart';

class ProfileFilterItem extends StatelessWidget {
  final String filterName;
  final int index;

  const ProfileFilterItem({
    super.key,
    required this.filterName,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewAlbumFrameCubit, NewAlbumFrameState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: index == state.filterIndex
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(255, 205, 178, 1),
                        Color.fromRGBO(255, 180, 162, 1),
                        Color.fromRGBO(229, 152, 155, 1),
                        Color.fromRGBO(181, 131, 141, 1),
                        Color.fromRGBO(109, 104, 117, 1),
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {},
                    child: Text(
                      filterName.toUpperCase(),
                      style: GoogleFonts.josefinSans(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                    ),
                    onPressed: () =>
                        context.read<NewAlbumFrameCubit>().changePage(index),
                    child: Text(
                      filterName.toUpperCase(),
                      style: GoogleFonts.josefinSans(
                        fontSize: 14,
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
