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
        int index = state.selectedAlbumIndex;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 60),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromRGBO(242, 243, 247, 1),
          ),
          //constraints: BoxConstraints(minWidth: 225, maxWidth: 300),
          height: 40,
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<Album>(
                value: state.unlockedAlbums.isNotEmpty
                    ? state.unlockedAlbums[index]
                    : null,
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(242, 243, 247, .75),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                isExpanded: true,
                iconStyleData: const IconStyleData(iconSize: 0),
                alignment: Alignment.center,
                items: state.unlockedAlbums
                    .map(
                      (e) => DropdownMenuItem<Album>(
                        value: e,
                        alignment: Alignment.center,
                        child: Text(
                          e.albumName,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
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
