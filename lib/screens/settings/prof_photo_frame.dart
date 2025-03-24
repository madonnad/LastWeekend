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
    double circleDiameter = devWidth * .20;
    ImagePicker picker = ImagePicker();

    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.read<SettingsCubit>().clearNewImageFile();
            Navigator.of(context).pop();
          },
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
            fontSize: 20,
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
                      errorListener: (_) {},
                    );
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                        width: double.infinity,
                      ),
                      CircleAvatar(
                        radius: circleDiameter,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            const AssetImage("lib/assets/placeholder.png"),
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
                                if (context.mounted) {
                                  context
                                      .read<SettingsCubit>()
                                      .addProfileImage(value);
                                }
                              }
                            },
                          ).catchError(
                            (error) {},
                          );
                        },
                        child: Container(
                          width: 75,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(44, 44, 44, 1),
                          ),
                          child: const Icon(
                            Icons.photo_library_rounded,
                            color: Colors.white70,
                            size: 25,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: settingsState.profileImageToUpload != null
                            ? () async {
                                await context
                                    .read<SettingsCubit>()
                                    .uploadProfilePicture()
                                    .then(
                                  (value) async {
                                    if (value) {
                                      if (context.mounted) {
                                        context
                                            .read<SettingsCubit>()
                                            .clearNewImageFile();

                                        await CachedNetworkImage.evictFromCache(
                                            state.user.avatarUrl);

                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    }
                                  },
                                );
                              }
                            : null,
                        child: Text("Update Photo"),
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
