import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/edit_album_dropdown.dart';
import 'package:shared_photo/models/captured_image.dart';

class CapturedEditScreen extends StatelessWidget {
  const CapturedEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        CapturedImage selectedImage =
            state.selectedImage ?? state.selectedAlbumImageList[0];
        int selectedIndex = state.selectedAlbumImageList.indexOf(selectedImage);

        return Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.white,
            ),
            title: const EditAlbumDropdown(
              opacity: .75,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 25),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        image: state.photosTaken.isNotEmpty
                            ? DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                  File(selectedImage.imageXFile.path),
                                ),
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<CameraCubit>().removePhotoFromList(
                                      context,
                                      state.selectedAlbumImageList[
                                          selectedIndex],
                                    );
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.white70,
                                  size: 30,
                                ),
                              ),
                            ),
                            BlocBuilder<CameraCubit, CameraState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () => context
                                      .read<CameraCubit>()
                                      .toggleMonthlyRecap(selectedImage),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectedImage.addToRecap
                                          ? Colors.grey.withOpacity(1)
                                          : Colors.grey.withOpacity(.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.add,
                                        color: selectedImage.addToRecap
                                            ? Colors.white.withOpacity(1)
                                            : Colors.white.withOpacity(.75),
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 15 + MediaQuery.of(context).viewInsets.bottom,
                      left: 20,
                      right: 20,
                    ),
                    child: BlocBuilder<CameraCubit, CameraState>(
                      builder: (context, state) {
                        return SizedBox(
                          height: 70,
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(19, 19, 19, 1),
                            child: Center(
                              child: TextField(
                                controller: state.captionTextController,
                                maxLines: null,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                style: GoogleFonts.josefinSans(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                onSubmitted: (_) => context
                                    .read<CameraCubit>()
                                    .updateImageCaption(selectedImage),
                                onChanged: (_) {
                                  Future.delayed(
                                      const Duration(milliseconds: 350));
                                  context
                                      .read<CameraCubit>()
                                      .updateImageCaption(selectedImage);
                                },
                                onTapOutside: (_) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  context
                                      .read<CameraCubit>()
                                      .updateImageCaption(selectedImage);
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  hintText: "Add Caption",
                                  hintStyle: GoogleFonts.josefinSans(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withOpacity(.75),
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  BlocBuilder<CameraCubit, CameraState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 100,
                        child: ListView.separated(
                          controller: ScrollController(
                            initialScrollOffset: 40.0 * selectedIndex,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.selectedAlbumImageList.length,
                          itemBuilder: (context, index) {
                            File listFile = File(state
                                .selectedAlbumImageList[index].imageXFile.path);
                            if (index == 0) {
                              return GestureDetector(
                                onTap: () => context
                                    .read<CameraCubit>()
                                    .updateSelectedImage(
                                        state.selectedAlbumImageList[index]),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Container(
                                    width: 80,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: selectedImage ==
                                              state
                                                  .selectedAlbumImageList[index]
                                          ? Border.all(
                                              color: Colors.white,
                                              width: 2.0,
                                            )
                                          : null,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(listFile),
                                      ),
                                      color:
                                          const Color.fromRGBO(19, 19, 19, 1),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () => context
                                  .read<CameraCubit>()
                                  .updateSelectedImage(
                                      state.selectedAlbumImageList[index]),
                              child: Container(
                                width: 80,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: selectedImage ==
                                          state.selectedAlbumImageList[index]
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        )
                                      : null,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(listFile),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 16),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();

                        context.read<CameraCubit>().uploadImagesToAlbums(
                            context.read<AppBloc>().state.user.token);
                      },
                      child: Container(
                        height: 60,
                        width: 175,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
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
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Add Photos",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
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

/*state.loading == true
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black87,
                    child: const SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),*/
