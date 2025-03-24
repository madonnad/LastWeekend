import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/screens/captured_image_list_screen.dart';

class CameraImageStack extends StatelessWidget {
  const CameraImageStack({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => BlocProvider<CameraCubit>.value(
                value: context.read<CameraCubit>(),
                child:
                    const CapturedImageListScreen(), //const CapturedEditScreen(),
              ),
            ));
          },
          child: Stack(
            children: List.generate(
              state.selectedAlbumImageList.length,
              (index) {
                if (index == (state.selectedAlbumImageList.length - 1)) {
                  return previewWidget(
                    filePath:
                        state.selectedAlbumImageList[index].imageXFile.path,
                    angle: 0,
                  );
                } else if (index == (state.selectedAlbumImageList.length - 2)) {
                  return previewWidget(
                    filePath:
                        state.selectedAlbumImageList[index].imageXFile.path,
                    angle: 12,
                  );
                } else if (index == (state.selectedAlbumImageList.length - 3)) {
                  return previewWidget(
                    filePath:
                        state.selectedAlbumImageList[index].imageXFile.path,
                    angle: -12,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )..add(
                Align(
                  alignment: Alignment.topRight,
                  child: imageCountIdentifier(
                      count: state.selectedAlbumImageList.length),
                ),
              ),
          ),
        );
      },
    );
  }
}

Widget imageCountIdentifier({required int count}) {
  String countString = count.toString();
  if (count > 99) {
    countString = "99+";
  }
  return count != 0
      ? Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: Colors.red, //const Color.fromRGBO(181, 141, 131, 1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              countString,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        )
      : const SizedBox(
          width: 75,
          height: 75,
        );
}

Widget previewWidget({required String filePath, required int angle}) {
  return Transform.rotate(
    angle: (angle * math.pi) / 180,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(
            File(filePath),
          ),
        ),
      ),
      //margin: const EdgeInsets.all(8.0),
      height: 75,
      width: 75,
    ),
  );
}
