import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/components/camera_comp/captured_image_list_comp/captured_image_item.dart';
import 'package:shared_photo/components/camera_comp/captured_image_list_comp/captured_list_fab.dart';
import 'package:shared_photo/components/camera_comp/edit_album_dropdown.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/empty_edit_view.dart';
import 'package:shared_photo/models/photo.dart';

import '../bloc/cubit/camera_cubit.dart';

class CapturedImageListScreen extends StatelessWidget {
  const CapturedImageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();

    void addListPhotos(List<XFile>? selectedImages) {
      if (selectedImages == null) return;

      context
          .read<CameraCubit>()
          .addListOfPhotosToList(selectedImages, UploadType.forgotShot);
    }

    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        bool itemsSelected = state.selectedAlbumSelectedImageList.isNotEmpty;

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
                  state.selectedAlbumImageList.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.selectedAlbumImageList.length,
                          itemBuilder: (context, item) => CapturedImageItem(
                            key: ValueKey(
                                state.selectedAlbumImageList[item].hashCode),
                            image: state.selectedAlbumImageList[item],
                          ),
                        )
                      : const EmptyEditView(),
                  Positioned(
                    bottom: 40,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        itemsSelected
                            ? CapturedListFab(
                                count:
                                    state.selectedAlbumSelectedImageList.length,
                                backgroundColor:
                                    const Color.fromRGBO(19, 19, 19, 1),
                                horizontalPadding: 15,
                                icon: Icons.delete_forever,
                                contentColor: Colors.white54,
                                borderRadius: 5,
                                onTap: () => context
                                    .read<CameraCubit>()
                                    .removeImageFromUploadList(),
                              )
                            : const SizedBox.shrink(),
                        (itemsSelected &&
                                state.selectedAlbumSelectedImageList.length !=
                                    state.selectedAlbumImageList.length)
                            ? const Gap(7)
                            : const Gap(0),
                        (itemsSelected &&
                                state.selectedAlbumSelectedImageList.length !=
                                    state.selectedAlbumImageList.length)
                            ? CapturedListFab(
                                count:
                                    state.selectedAlbumSelectedImageList.length,
                                backgroundColor:
                                    const Color.fromRGBO(136, 98, 106, 1),
                                horizontalPadding: 15,
                                icon: Icons.upload_rounded,
                                contentColor: Colors.white.withOpacity(.75),
                                borderRadius: 5,
                                onTap: () => context
                                    .read<CameraCubit>()
                                    .uploadSelectedPhotos(),
                              )
                            : const SizedBox.shrink(),
                        itemsSelected ? const Gap(7) : const Gap(0),
                        state.selectedAlbumImageList.isNotEmpty
                            ? CapturedListFab(
                                count: state.selectedAlbumImageList.length,
                                backgroundColor:
                                    const Color.fromRGBO(181, 131, 141, 1),
                                horizontalPadding: 25,
                                icon: Icons.upload_rounded,
                                contentColor: Colors.white,
                                borderRadius: 5,
                                onTap: () => context
                                    .read<CameraCubit>()
                                    .uploadAllImagesToAlbum(),
                              )
                            : const SizedBox.shrink(),
                        const Gap(7),
                        CapturedListFab(
                          backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                          horizontalPadding: 15,
                          icon: Icons.add_photo_alternate_rounded,
                          contentColor: Colors.white,
                          borderRadius: 5,
                          onTap: () async {
                            List<XFile>? selectedImages =
                                await imagePicker.pickMultiImage();

                            addListPhotos(selectedImages);
                          },
                        )
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
