import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/screens/captured_image_list_screen.dart';

class EmptyAlbumView extends StatelessWidget {
  final bool isUnlockPhase;
  final Album album;

  const EmptyAlbumView(
      {super.key, required this.isUnlockPhase, required this.album});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "There’s nothing here 🙃",
          style: GoogleFonts.josefinSans(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(25),
        isUnlockPhase
            ? Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop("showCamera");
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 70),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 205, 178, 1),
                              Color.fromRGBO(255, 180, 162, 1),
                              Color.fromRGBO(229, 152, 155, 1),
                              Color.fromRGBO(181, 131, 141, 1),
                              Color.fromRGBO(109, 104, 117, 1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: Center(
                        child: Text(
                          "Snap a Pic",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(15),
                  Text(
                    "or",
                    style: GoogleFonts.josefinSans(
                      color: Colors.white54,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(15),
                ],
              )
            : const Gap(0),
        GestureDetector(
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            builder: (ctx) {
              return BlocProvider(
                create: (context) => CameraCubit(
                  dataRepository: context.read<DataRepository>(),
                  user: context.read<AppBloc>().state.user,
                  mode: UploadMode.singleAlbum,
                  album: album,
                ),
                child: const CapturedImageListScreen(),
              );
            },
          ),
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 70),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(44, 44, 44, 1),
            ),
            child: Center(
              child: Text(
                "Add Forgot Shot",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
