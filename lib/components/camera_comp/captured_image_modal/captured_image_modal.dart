import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/captured_image_list_comp/captured_list_fab.dart';
import 'package:shared_photo/components/camera_comp/captured_image_modal/captured_modal_page_view.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/download_image_button.dart';
import 'package:shared_photo/components/camera_comp/edit_screen_comp/move_album_modal.dart';

class CapturedImageModal extends StatefulWidget {
  const CapturedImageModal({super.key});

  @override
  State<CapturedImageModal> createState() => _CapturedImageModalState();
}

class _CapturedImageModalState extends State<CapturedImageModal> {
  TextEditingController controller = TextEditingController();
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCubit, CameraState>(
      listenWhen: (previous, current) =>
          previous.selectedAlbumImageList != current.selectedAlbumImageList,
      listener: (context, state) {
        if (state.selectedAlbumImageList.isEmpty) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: state.mode == UploadMode.unlockedAlbums
                  ? const Icon(Icons.close)
                  : const Icon(Icons.close),
              color: Colors.white,
            ),
            // title: const EditAlbumDropdown(
            //   opacity: .75,
            // ),
            centerTitle: true,
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.selectedImage != null
                    ? Flexible(
                        fit: FlexFit.tight,
                        child: CapturedModalPageView(
                          selectedAlbumImageList: state.selectedAlbumImageList,
                          selectedImage: state.selectedImage!,
                        ))
                    : const SizedBox(
                        height: 100,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CapturedListFab(
                      backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
                      horizontalPadding: 12,
                      icon: Icons.delete_forever,
                      contentColor: Colors.white,
                      borderRadius: 5,
                      onTap: () =>
                          context.read<CameraCubit>().deleteSelectedImage(),
                    ),
                    const Gap(10),
                    CapturedListFab(
                      backgroundColor: const Color.fromRGBO(181, 131, 141, 1),
                      horizontalPadding: 12,
                      icon: Icons.upload_rounded,
                      contentColor: Colors.white,
                      borderRadius: 5,
                      onTap: () =>
                          context.read<CameraCubit>().uploadSelectedImage(),
                    ),
                    const Gap(10),
                    CapturedListFab(
                      backgroundColor: const Color.fromRGBO(181, 131, 141, 1),
                      horizontalPadding: 12,
                      icon: Icons.swap_horiz,
                      contentColor: Colors.white,
                      borderRadius: 5,
                      onTap: () => showDialog(
                          context: context,
                          builder: (ctx) {
                            return BlocProvider.value(
                              value: context.read<CameraCubit>(),
                              child: const MoveAlbumModal(),
                            );
                          }),
                    ),
                    const Gap(10),
                    const DownloadImageButton()
                  ],
                ),
                Gap(MediaQuery.of(context).viewPadding.bottom + 15),
              ],
            ),
          ),
        );
      },
    );
  }
}
