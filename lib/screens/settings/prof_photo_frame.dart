import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/settings_cubit.dart';

class ProfPhotoFrame extends StatelessWidget {
  const ProfPhotoFrame({super.key});

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double circleDiameter = devWidth * .25;
    ImagePicker picker = ImagePicker();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 25,
          ),
        ),
        title: Text(
          "Edit Profile Picture",
          style: GoogleFonts.josefinSans(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {
              String filePath = settingsState.profileImageToUpload?.path ?? '';
              ImageProvider image = settingsState.profileImageToUpload != null
                  ? FileImage(File(filePath)) as ImageProvider
                  : CachedNetworkImageProvider(
                      state.user.avatarUrl,
                      headers: state.user.headers,
                    );
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 60,
                        width: double.infinity,
                      ),
                      CircleAvatar(
                        radius: circleDiameter,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            const AssetImage("lib/assets/default.png"),
                        foregroundImage: image,
                        onForegroundImageError: (_, __) {},
                      ),
                      const SizedBox(
                        height: 30,
                        width: double.infinity,
                      ),
                      InkWell(
                        onTap: () {
                          picker.pickImage(source: ImageSource.gallery).then(
                            (value) {
                              if (value != null) {
                                context
                                    .read<SettingsCubit>()
                                    .addProfileImage(value);
                              }
                            },
                          ).catchError(
                            (error) {},
                          );
                        },
                        child: Container(
                          width: 100,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(44, 44, 44, 1),
                          ),
                          child: const Icon(
                            Icons.photo_library_rounded,
                            color: Colors.white70,
                            size: 35,
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          if (settingsState.profileImageToUpload != null) {
                            context
                                .read<SettingsCubit>()
                                .uploadProfilePicture()
                                .then((value) {
                              if (value) {
                                context
                                    .read<SettingsCubit>()
                                    .clearNewImageFile();
                                Navigator.of(context).pop();
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: settingsState.profileImageToUpload != null
                                ? const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(255, 205, 178, 1),
                                      Color.fromRGBO(255, 180, 162, 1),
                                      Color.fromRGBO(229, 152, 155, 1),
                                      Color.fromRGBO(181, 131, 141, 1),
                                      Color.fromRGBO(109, 104, 117, 1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(255, 205, 178, .5),
                                      Color.fromRGBO(255, 180, 162, .5),
                                      Color.fromRGBO(229, 152, 155, .5),
                                      Color.fromRGBO(181, 131, 141, .5),
                                      Color.fromRGBO(109, 104, 117, .5),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                          ),
                          child: Center(
                            child: Text(
                              "Update Photo",
                              style: GoogleFonts.montserrat(
                                color:
                                    settingsState.profileImageToUpload != null
                                        ? Colors.white
                                        : Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 75),
                    ],
                  ),
                  settingsState.loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox(height: 0),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
