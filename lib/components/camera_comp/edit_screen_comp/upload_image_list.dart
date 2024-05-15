import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/captured_image.dart';

class UploadImageList extends StatelessWidget {
  final CapturedImage selectedImage;
  final int selectedIndex;
  const UploadImageList({
    super.key,
    required this.selectedImage,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return SizedBox(
          height: 100,
          child: ListView.separated(
            controller: ScrollController(
              initialScrollOffset: 40.0 * selectedIndex,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: state.selectedAlbumImageList.length,
            itemBuilder: (context, index) {
              File listFile =
                  File(state.selectedAlbumImageList[index].imageXFile.path);
              if (index == 0) {
                return GestureDetector(
                  onTap: () => context
                      .read<CameraCubit>()
                      .updateSelectedImage(state.selectedAlbumImageList[index]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Container(
                      width: 80,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border:
                            selectedImage == state.selectedAlbumImageList[index]
                                ? Border.all(
                                    color: Colors.white,
                                    width: 2.0,
                                  )
                                : null,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(listFile),
                        ),
                        color: const Color.fromRGBO(19, 19, 19, 1),
                      ),
                    ),
                  ),
                );
              }
              return GestureDetector(
                onTap: () => context
                    .read<CameraCubit>()
                    .updateSelectedImage(state.selectedAlbumImageList[index]),
                child: Container(
                  width: 80,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: selectedImage == state.selectedAlbumImageList[index]
                        ? Border.all(
                            color: Colors.white,
                            width: 2.0,
                          )
                        : null,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(listFile),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
          ),
        );
      },
    );
  }
}
