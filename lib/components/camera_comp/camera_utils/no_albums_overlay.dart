import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/album.dart';

class NoAlbumsOverlay extends StatelessWidget {
  const NoAlbumsOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        Album? selectedAlbum = state.selectedAlbum;

        return selectedAlbum == null
            ? Container(
                width: size.width,
                height: size.height,
                color: Colors.black87,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "😔",
                          style: TextStyle(fontSize: 50),
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "No Albums Currently Unlocked!",
                          style: GoogleFonts.lato(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "Once an album reaches the unlock state - then the camera will be available",
                          style: GoogleFonts.josefinSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
