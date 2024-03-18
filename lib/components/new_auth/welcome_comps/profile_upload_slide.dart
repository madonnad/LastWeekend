import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/welcome_cubit.dart';
import 'package:shared_photo/components/new_auth/confirm_button.dart';
import 'package:shared_photo/components/new_auth/welcome_comps/profile_picture_upload.dart';

class ProfileUploadSlide extends StatelessWidget {
  const ProfileUploadSlide({super.key});

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    String uid = context.read<AppBloc>().state.user.id;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Center(
          child: Text(
            "Add Profile Picture",
            style: GoogleFonts.montserrat(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 20),
        const ProfilePictureUpload(),
        const SizedBox(height: 20),
        SizedBox(
          width: MediaQuery.of(context).size.width * .6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // InkWell(
              //   onTap: () {},
              //   child: Container(
              //     width: MediaQuery.of(context).size.width * .28,
              //     height: 60,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: const Color.fromRGBO(44, 44, 44, 1),
              //     ),
              //     child: const Icon(
              //       Icons.camera_alt_rounded,
              //       color: Colors.white70,
              //       size: 45,
              //     ),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  picker.pickImage(source: ImageSource.gallery).then(
                    (value) {
                      if (value != null) {
                        context.read<WelcomeCubit>().addProfileImage(value);
                      }
                    },
                  ).catchError(
                    (error) {},
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .28,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(44, 44, 44, 1),
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: Colors.white70,
                    size: 45,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            context.read<AppBloc>().add(const ChangeNewAccountEvent());
            Navigator.of(context).pop();
          },
          child: Text(
            "Add one later",
            style: GoogleFonts.montserrat(
              color: Colors.white54,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(flex: 2),
        BlocBuilder<WelcomeCubit, WelcomeState>(
          builder: (context, state) {
            return ConfirmButton(
              buttonText: "Add Image",
              onTap: state.profileImageToUpload != null
                  ? () async => await context
                          .read<WelcomeCubit>()
                          .uploadProfilePicture(uid)
                          .then(
                        (value) {
                          if (value) {
                            context
                                .read<AppBloc>()
                                .add(const ChangeNewAccountEvent());
                            Navigator.of(context).pop();
                          }
                        },
                      )
                  : null,
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}
