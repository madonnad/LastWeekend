import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/image_frame_cubit.dart';
import 'package:shared_photo/bloc/cubit/new_album_frame_cubit.dart';

class ImageFrameAppBar extends StatelessWidget {
  const ImageFrameAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageFrameCubit, ImageFrameState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  value: state.filterList[state.filterIndex],
                  style: GoogleFonts.josefinSans(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  iconStyleData: const IconStyleData(
                    iconSize: 0,
                    openMenuIcon: Icon(Icons.arrow_drop_up),
                  ),
                  dropdownStyleData: const DropdownStyleData(
                    //isOverButton: true,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  items: state.filterList
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != state.filterList[state.filterIndex]) {
                      context.read<ImageFrameCubit>().changeViewMode(value);
                    }
                  },
                ),
              ),
              const Icon(
                Icons.close,
                color: Colors.transparent,
                size: 25,
              ),
            ],
          ),
        );
      },
    );
  }
}
