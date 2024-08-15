import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/camera_comp/captured_image_list_comp/captured_image_item.dart';
import 'package:shared_photo/components/camera_comp/captured_image_list_comp/captured_list_fab.dart';
import 'package:shared_photo/components/camera_comp/edit_album_dropdown.dart';

import '../bloc/cubit/camera_cubit.dart';

class CapturedImageListScreen extends StatelessWidget {
  const CapturedImageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: state.mode == UploadMode.unlockedAlbums
                    ? const Icon(Icons.arrow_back_ios_new)
                    : const Icon(Icons.close),
                color: Colors.white,
              ),
              title: const EditAlbumDropdown(
                opacity: .75,
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: state.selectedAlbumImageList.length,
                    itemBuilder: (context, item) => CapturedImageItem(
                      imagePath:
                          state.selectedAlbumImageList[item].imageXFile.path,
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CapturedListFab(
                          count: 0,
                          backgroundColor: Color.fromRGBO(19, 19, 19, 1),
                          horizontalPadding: 15,
                          icon: Icons.delete_forever,
                          contentColor: Colors.white54,
                          borderRadius: 5,
                        ),
                        const Gap(7),
                        const CapturedListFab(
                          count: 0,
                          backgroundColor: Color.fromRGBO(136, 98, 106, 1),
                          horizontalPadding: 15,
                          icon: Icons.upload_rounded,
                          contentColor: Colors.white54,
                          borderRadius: 5,
                        ),
                        const Gap(7),
                        CapturedListFab(
                          count: state.selectedAlbumImageList.length,
                          backgroundColor:
                              const Color.fromRGBO(181, 131, 141, 1),
                          horizontalPadding: 25,
                          icon: Icons.upload_rounded,
                          contentColor: Colors.white,
                          borderRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
