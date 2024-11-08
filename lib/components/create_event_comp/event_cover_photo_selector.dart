import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';

class EventCoverPhotoSelector extends StatelessWidget {
  const EventCoverPhotoSelector({super.key});

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();

    void addImageToCubit(XFile value) {
      context.read<CreateAlbumCubit>().addImage(value.path);
    }

    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              picker.pickImage(source: ImageSource.gallery).then(
                (value) {
                  if (value != null) {
                    addImageToCubit(value);
                  }
                },
              ).catchError(
                (error) {},
              );
            },
            child: DottedBorder(
              color: const Color.fromRGBO(181, 131, 141, .75),
              borderType: BorderType.RRect,
              borderPadding: const EdgeInsets.all(4),
              radius: const Radius.circular(20),
              dashPattern: const [4, 4],
              strokeWidth: 2,
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: state.albumCoverImagePath != null
                      ? DecorationImage(
                          image: FileImage(
                            File(state.albumCoverImagePath!),
                          ),
                          fit: BoxFit.cover)
                      : null,
                ),
                child: Center(
                  child: state.albumCoverImagePath == null
                      ? Text(
                          "Cover\nPhoto".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            color: Colors.white54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
