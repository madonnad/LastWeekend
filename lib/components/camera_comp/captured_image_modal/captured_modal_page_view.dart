import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/captured_image_modal/captured_image_loading_bar.dart';
import 'package:shared_photo/models/captured_image.dart';

class CapturedModalPageView extends StatefulWidget {
  final List<CapturedImage> selectedAlbumImageList;
  final CapturedImage selectedImage;
  const CapturedModalPageView({
    super.key,
    required this.selectedAlbumImageList,
    required this.selectedImage,
  });

  @override
  State<CapturedModalPageView> createState() => _CapturedModalPageViewState();
}

class _CapturedModalPageViewState extends State<CapturedModalPageView> {
  late PageController pageController;
  late TextEditingController textEditingController;
  late CapturedImage _selectedImage;
  int page = 0;
  bool controllerMoved = false;

  @override
  void initState() {
    _selectedImage = widget.selectedImage;
    page = widget.selectedAlbumImageList.indexOf(_selectedImage);
    pageController = PageController(viewportFraction: .9, initialPage: page);
    textEditingController = TextEditingController(text: _selectedImage.caption);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CameraCubit, CameraState>(
      listenWhen: (previous, current) =>
          previous.selectedAlbumImageList != current.selectedAlbumImageList,
      listener: (context, state) {
        page = state.selectedAlbumImageList
            .indexWhere((test) => test == state.selectedImage!);

        textEditingController =
            TextEditingController(text: state.selectedImage?.caption);
      },
      builder: (context, state) {
        void updateSelectedImage(int index) {
          context
              .read<CameraCubit>()
              .updateSelectedImage(state.selectedAlbumImageList[index]);

          textEditingController = TextEditingController(
              text: state.selectedAlbumImageList[index].caption);
        }

        return Column(
          children: [
            Flexible(
              child: PageView.builder(
                controller: pageController,
                itemCount: widget.selectedAlbumImageList.length,
                onPageChanged: (index) => updateSelectedImage(index),
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: FittedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image(
                          alignment: Alignment.topCenter,
                          fit: BoxFit.contain,
                          image: FileImage(
                            File(
                              state.selectedAlbumImageList[index].imageXFile
                                  .path,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: MediaQuery.of(context).size.width * .1 - 10,
              ),
              child: CapturedImageLoadingBar(image: widget.selectedImage),
            ),
            Container(
              height: 75,
              margin: EdgeInsets.only(
                bottom: 10,
                left: MediaQuery.of(context).size.width * .1 - 10,
                right: MediaQuery.of(context).size.width * .1 - 10,
              ),
              child: TextField(
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                onChanged: (text) {
                  if (state.selectedImage != null) {
                    context
                        .read<CameraCubit>()
                        .updateImageCaptionWithText(state.selectedImage!, text);
                  }
                },
                maxLines: null,
                expands: true,
                controller: textEditingController,
                textAlignVertical: TextAlignVertical.center,
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  hintText: "Add Caption",
                  hintStyle: GoogleFonts.lato(
                    color: Colors.white54,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(19, 19, 19, 1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(19, 19, 19, 1),
                    ),
                  ),
                  fillColor: const Color.fromRGBO(44, 44, 44, 1),
                  filled: true,
                ),
              ),
            ),
            MediaQuery.of(context).viewInsets.bottom - 85 > 0
                ? Gap(MediaQuery.of(context).viewInsets.bottom - 85)
                : const Gap(0),
          ],
        );
      },
    );
  }
}
