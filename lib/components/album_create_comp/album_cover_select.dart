import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/cubit/create_album_cubit.dart';

class AlbumCoverSelect extends StatelessWidget {
  const AlbumCoverSelect({super.key});

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 1,
          child: InkWell(
            onTap: () {
              picker.pickImage(source: ImageSource.gallery).then(
                (value) {
                  if (value != null) {
                    context.read<CreateAlbumCubit>().addImage(value.path);
                  }
                },
              ).catchError(
                (error) {},
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * .40,
              width: MediaQuery.of(context).size.width * .65,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(243, 240, 240, 100),
              ),
              child: state.albumCoverImagePath == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'album cover',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            color: Colors.black45,
                          ),
                        ),
                        const Icon(
                          Icons.add,
                          size: 25,
                          color: Colors.black45,
                        )
                      ],
                    )
                  : Image.file(
                      File(state.albumCoverImagePath!),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        );
      },
    );
  }
}
