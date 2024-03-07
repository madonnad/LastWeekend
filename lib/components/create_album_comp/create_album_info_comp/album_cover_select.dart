import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/cubit/create_album_cubit.dart';

class AlbumCoverSelect extends StatelessWidget {
  const AlbumCoverSelect({super.key});

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return AspectRatio(
          aspectRatio: 5 / 7,
          child: Card(
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
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(19, 19, 19, 1),
                ),
                child: state.albumCoverImagePath == null
                    ? const Icon(
                        Icons.add_circle_outline,
                        size: 35,
                        color: Colors.white,
                      )
                    : Image.file(
                        File(state.albumCoverImagePath!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
