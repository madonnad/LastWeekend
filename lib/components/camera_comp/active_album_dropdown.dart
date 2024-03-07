import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/album.dart';

class ActiveAlbumDropdown extends StatelessWidget {
  final double opacity;

  const ActiveAlbumDropdown({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withOpacity(opacity),
          ),
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<Album>(
                value: state.selectedAlbum,
                style: GoogleFonts.josefinSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                iconStyleData: const IconStyleData(iconSize: 0),
                items: state.unlockedAlbums
                    .map(
                      (e) => DropdownMenuItem<Album>(
                        value: e,
                        child: Text(
                          e.albumName,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (album) =>
                    context.read<CameraCubit>().changeSelectedAlbum(album),
              ),
            ),
          ),
        );
      },
    );
  }
}

/*

Center(
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withOpacity(0.25),
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: DropdownButton(
                  value: activeAlbumNames[0].albumId,
                  borderRadius: BorderRadius.circular(10),
                  dropdownColor: Colors.white,
                  underline: const SizedBox(),
                  isDense: false,
                  iconSize: 0,
                  style: GoogleFonts.josefinSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  items: activeAlbumNames.map((Album active) {
                    return DropdownMenuItem(
                      value: active.albumId,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              active.albumName,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (text) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );*/
