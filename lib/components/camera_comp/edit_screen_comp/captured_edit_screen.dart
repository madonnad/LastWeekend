import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/edit_album_dropdown.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/edit_caption_field.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/edit_image_preview.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/empty_edit_view.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/submit_image_button.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/upload_image_list.dart';
import 'package:shared_photo/models/captured_image.dart';

class CapturedEditScreen extends StatelessWidget {
  const CapturedEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        late CapturedImage selectedImage;
        late int selectedIndex;
        if (state.photosTaken.isNotEmpty) {
          selectedImage =
              state.selectedImage ?? state.selectedAlbumImageList[0];
          selectedIndex = state.selectedAlbumImageList.indexOf(selectedImage);
        }

        return SafeArea(
          child: Stack(
            children: [
              Scaffold(
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
                body: state.photosTaken.isNotEmpty
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
                              const Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: SubmitImageButton(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const EmptyEditView(),
              ),
              state.loading
                  ? Container(
                      color: Colors.black45,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      },
    );
  }
}
