import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/models/album.dart';

class VisibilityToggleSwitch extends StatelessWidget {
  const VisibilityToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return AnimatedToggleSwitch<AlbumVisibility>.size(
          current: state.visibility,
          values: const [
            AlbumVisibility.public,
            AlbumVisibility.friends,
            AlbumVisibility.private
          ],
          indicatorSize: const Size.fromHeight(50),
          selectedIconScale: 1.05,
          style: const ToggleStyle(
            backgroundColor: Color.fromRGBO(19, 19, 19, 1),
            borderColor: Color.fromRGBO(19, 19, 19, 1),
            indicatorGradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 205, 178, 1),
                Color.fromRGBO(255, 180, 162, 1),
                Color.fromRGBO(229, 152, 155, 1),
                Color.fromRGBO(181, 131, 141, 1),
                Color.fromRGBO(109, 104, 117, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            indicatorBorderRadius: BorderRadius.all(Radius.circular(30)),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          iconBuilder: (value) {
            bool isSelected = state.visibility == value;
            switch (value) {
              case AlbumVisibility.public:
                return Text(
                  "Public",
                  style: GoogleFonts.montserrat(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              case AlbumVisibility.friends:
                return Text(
                  "Friends",
                  style: GoogleFonts.montserrat(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              case AlbumVisibility.private:
                return Text(
                  "Private",
                  style: GoogleFonts.montserrat(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.white,
                  ),
                );
              default:
                return const Text("Other");
            }
          },
          onChanged: (value) =>
              context.read<CreateAlbumCubit>().setVisibilityMode(value),
        );
      },
    );
  }
}
