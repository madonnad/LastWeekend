import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';

class SubmitImageButton extends StatelessWidget {
  const SubmitImageButton({super.key});

  @override
  Widget build(BuildContext context) {
    void closePage() {
      Navigator.of(context).pop();
    }

    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: state.photosTaken.isNotEmpty
              ? () async {
                  await context.read<CameraCubit>().uploadImagesToAlbums(
                      context.read<AppBloc>().state.user.token);

                  closePage();
                }
              : () {},
          child: Container(
            height: 60,
            width: 175,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: state.photosTaken.isNotEmpty
                    ? const [
                        Color.fromRGBO(255, 205, 178, 1),
                        Color.fromRGBO(255, 180, 162, 1),
                        Color.fromRGBO(229, 152, 155, 1),
                        Color.fromRGBO(181, 131, 141, 1),
                        Color.fromRGBO(109, 104, 117, 1),
                      ]
                    : const [
                        Color.fromRGBO(255, 205, 178, 0.5),
                        Color.fromRGBO(255, 180, 162, 0.5),
                        Color.fromRGBO(229, 152, 155, 0.5),
                        Color.fromRGBO(181, 131, 141, 0.5),
                        Color.fromRGBO(109, 104, 117, 0.5),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                "Upload",
                style: GoogleFonts.montserrat(
                  color: state.photosTaken.isNotEmpty
                      ? Colors.white
                      : Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
