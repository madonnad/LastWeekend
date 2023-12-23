import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/camera_cubit.dart';
import 'package:shared_photo/components/camera_comp/active_album_dropdown.dart';

class CapturedEditScreen extends StatelessWidget {
  const CapturedEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        int selectedIndex = state.selectedIndex ?? 0;
        File heroFile = File(state.photosTaken[selectedIndex].path);
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
            title: const ActiveAlbumDropdown(
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
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(heroFile),
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
                    child: SizedBox(
                      height: 70,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(19, 19, 19, 1),
                        child: Center(
                          child: TextField(
                            maxLines: null,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            textCapitalization: TextCapitalization.sentences,
                            style: GoogleFonts.josefinSans(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                            onTapOutside: (_) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
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
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.photosTaken.length,
                      itemBuilder: (context, index) {
                        File listFile = File(state.photosTaken[index].path);
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () => context
                                .read<CameraCubit>()
                                .updateSelectedIndex(index),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Container(
                                width: 80,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(listFile),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () => context
                              .read<CameraCubit>()
                              .updateSelectedIndex(index),
                          child: Container(
                            width: 80,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
