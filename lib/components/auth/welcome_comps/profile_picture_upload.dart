import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/welcome_cubit.dart';

class ProfilePictureUpload extends StatelessWidget {
  const ProfilePictureUpload({super.key});

  @override
  Widget build(BuildContext context) {
    double devWidth = MediaQuery.of(context).size.width;
    double circleDiameter = devWidth * .5;

    return BlocBuilder<WelcomeCubit, WelcomeState>(
      builder: (context, state) {
        String filePath = state.profileImageToUpload?.path ?? '';
        return Container(
          width: circleDiameter,
          height: circleDiameter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circleDiameter / 2),
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
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                radius: circleDiameter,
                backgroundColor: Colors.transparent,
                backgroundImage: const AssetImage("lib/assets/default.png"),
                foregroundImage: FileImage(File(filePath)),
              ),
            ],
          ),
        );
      },
    );
  }
}
