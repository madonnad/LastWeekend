import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/components/camera_comp/captured_image_list_comp/captured_image_item.dart';
import 'package:shared_photo/components/camera_comp/captured_image_list_comp/captured_list_fab.dart';
import 'package:shared_photo/components/camera_comp/edit_album_dropdown.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/empty_edit_view.dart';

import '../bloc/cubit/camera_cubit.dart';

class CapturedImageListScreen extends StatelessWidget {
  const CapturedImageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();

    void addListPhotos(List<XFile>? selectedImages) {
      if (selectedImages == null) return;

      context.read<CameraCubit>().addListOfPhotosToList(selectedImages);
    }

    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        bool itemsSelected = state.selectedAlbumToggleImageList.isNotEmpty;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          //backgroundColor: Colors.black,
          appBar: AppBar(
            //backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: state.mode == UploadMode.unlockedAlbums
                  ? const Icon(Icons.arrow_back_ios_new)
                  : const Icon(Icons.close),
              color: Colors.white,
            ),
            leadingWidth: 56,
            title: const EditAlbumDropdown(),
            centerTitle: true,
            actions: [
              Icon(
                Icons.train,
                color: Colors.transparent,
              )
            ],
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                state.selectedAlbumImageList.isNotEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom:
                                  MediaQuery.of(context).viewInsets.bottom == 0
                                      ? 75
                                      : MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          15),
                          child: ListView.builder(
                            itemCount: state.selectedAlbumImageList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, item) {
                              return CapturedImageItem(
                                key: ValueKey(state
                                    .selectedAlbumImageList[item].hashCode),
                                image: state.selectedAlbumImageList[item],
                              );
                            },
                          ),
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
                              count: state.selectedAlbumToggleImageList.length,
                              backgroundColor:
                                  const Color.fromRGBO(19, 19, 19, 1),
                              horizontalPadding: 15,
                              icon: Icons.delete_forever,
                              contentColor: Colors.white54,
                              borderRadius: 5,
                              onTap: () => context
                                  .read<CameraCubit>()
                                  .removeToggledImagesFromUploadList(),
                            )
                          : const SizedBox.shrink(),
                      (itemsSelected &&
                              state.selectedAlbumToggleImageList.length !=
                                  state.selectedAlbumImageList.length)
                          ? const Gap(7)
                          : const Gap(0),
                      (itemsSelected &&
                              state.selectedAlbumToggleImageList.length !=
                                  state.selectedAlbumImageList.length)
                          ? CapturedListFab(
                              count: state.selectedAlbumToggleImageList.length,
                              backgroundColor:
                                  const Color.fromRGBO(255, 98, 96, .75),
                              horizontalPadding: 15,
                              icon: Icons.upload_rounded,
                              contentColor: Colors.white.withOpacity(.75),
                              borderRadius: 5,
                              onTap: () => context
                                  .read<CameraCubit>()
                                  .uploadToggledPhotos(),
                            )
                          : const SizedBox.shrink(),
                      itemsSelected ? const Gap(7) : const Gap(0),
                      state.selectedAlbumImageList.isNotEmpty
                          ? CapturedListFab(
                              count: state.selectedAlbumImageList.length,
                              backgroundColor:
                                  const Color.fromRGBO(255, 98, 96, 1),
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
                              await imagePicker.pickMultiImage(
                                  maxHeight: 2160,
                                  maxWidth: 2160,
                                  imageQuality: 85);

                          addListPhotos(selectedImages);
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
