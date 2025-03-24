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
    return Builder(builder: (context) {
      if (album.albumId == '') {
        return Center(
          child: Text(
            "There’s nothing here 🙃",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "There’s nothing here 🙃",
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(25),
            isUnlockPhase
                ? Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop("showCamera");
                        },
                        child: Text(
                          "Snap a pic",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const Gap(15),
                      Text(
                        "or",
                        style: GoogleFonts.lato(
                          color: Colors.white54,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : const Gap(0),
            TextButton(
              onPressed: () => showModalBottomSheet(
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
              child: Text("Add forgot shot"),
            )
          ],
        );
      }
    });
  }
}
