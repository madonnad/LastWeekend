import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/edit_album_dropdown.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/download_image_button.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/edit_caption_field.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/edit_image_preview.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/empty_edit_view.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/submit_image_button.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/upload_image_list.dart';
import 'package:shared_photo/models/captured_image.dart';
import 'package:shared_photo/models/photo.dart';

class CapturedEditScreen extends StatelessWidget {
  const CapturedEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ImagePicker imagePicker = ImagePicker();

    void addListPhotos(List<XFile>? selectedImages) {
      if (selectedImages == null) return;

      context.read<CameraCubit>().addListOfPhotosToList(
            selectedImages,
            UploadType.forgotShot,
          );
    }

    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        late CapturedImage selectedImage;
        late int selectedIndex;
        if (state.selectedAlbumImageList.isNotEmpty) {
          selectedImage =
              state.selectedImage ?? state.selectedAlbumImageList[0];
          selectedIndex = state.selectedAlbumImageList.indexOf(selectedImage);
        }

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
            body: Stack(
              children: [
                state.selectedAlbumImageList.isNotEmpty
                    ? SingleChildScrollView(
                        child: SafeArea(
                          child: Column(
                            children: [
                              EditImagePreview(
                                selectedImage: selectedImage,
                                selectedIndex: selectedIndex,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 15 +
                                      MediaQuery.of(context).viewInsets.bottom,
                                  left: 20,
                                  right: 20,
                                ),
                                child: EditCaptionField(
                                    selectedImage: selectedImage),
                              ),
                              UploadImageList(
                                selectedImage: selectedImage,
                                selectedIndex: selectedIndex,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const DownloadImageButton(),
                                    const Gap(10),
                                    const SubmitImageButton(),
                                    const Gap(10),
                                    InkWell(
                                      onTap: () async {
                                        List<XFile>? selectedImages =
                                            await imagePicker.pickMultiImage();
                                        addListPhotos(selectedImages);
                                      },
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              44, 44, 44, 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          "😅",
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const EmptyEditView(),
                state.loading
                    ? Container(
                        color: Colors.black45,
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        );
      },
    );
  }
}
