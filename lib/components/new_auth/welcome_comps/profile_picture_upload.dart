import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/welcome_cubit.dart';

class ProfilePictureUpload extends StatelessWidget {
  const ProfilePictureUpload({super.key});

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double circleDiameter = devWidth * .35;

    return BlocBuilder<WelcomeCubit, WelcomeState>(
      builder: (context, state) {
        String filePath = state.profileImageToUpload?.path ?? '';
        return Container(
          width: circleDiameter,
          height: circleDiameter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circleDiameter / 2),
          ),
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: circleDiameter,
                backgroundColor: Colors.transparent,
                backgroundImage: const AssetImage("lib/assets/placeholder.png"),
                foregroundImage: FileImage(File(filePath)),
                onForegroundImageError: (exception, stackTrace) {},
              ),
            ],
          ),
        );
      },
    );
  }
}
