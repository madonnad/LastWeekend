import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/welcome_cubit.dart';
import 'package:shared_photo/components/new_auth/welcome_comps/profile_picture_upload.dart';

class ProfileUploadSlide extends StatelessWidget {
  final String name;
  const ProfileUploadSlide({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();
    String uid = context.read<AppBloc>().state.user.id;
    return BlocConsumer<WelcomeCubit, WelcomeState>(
      listenWhen: (previous, current) => current.exception.errorString != null,
      listener: (context, state) {
        String errorString = "${state.exception.errorString} ";
        SnackBar snackBar = SnackBar(
          backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
          content: Text(errorString),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(25),
            Center(
              child: Text(
                "Welcome $name!",
                style: GoogleFonts.lato(
                  color: Color.fromRGBO(242, 243, 247, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Spacer(),
            Column(
              children: [
                Center(
                  child: Text(
                    "Add Profile Picture",
                    style: GoogleFonts.lato(
                      color: Color.fromRGBO(242, 243, 247, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Gap(20),
                const ProfilePictureUpload(),
                const Gap(20),
                OutlinedButton(
                  onPressed: () {
                    picker.pickImage(source: ImageSource.gallery).then(
                      (value) {
                        if (value != null) {
                          if (context.mounted) {
                            context.read<WelcomeCubit>().addProfileImage(value);
                          }
                        }
                      },
                    ).catchError(
                      (error) {},
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 2.0,
                      color: Color.fromRGBO(242, 243, 247, 1),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  ),
                  child: Text(
                    "Open Gallery",
                    style: GoogleFonts.lato(
                      color: Color.fromRGBO(242, 243, 247, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AppBloc>().add(const ChangeNewAccountEvent());
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  ),
                  child: Text(
                    "Add later",
                    style: GoogleFonts.lato(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(242, 243, 247, .75),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(flex: 2),
            ElevatedButton(
              onPressed: state.profileImageToUpload != null
                  ? () async => await context
                          .read<WelcomeCubit>()
                          .uploadProfilePicture(uid)
                          .then(
                        (value) {
                          if (value) {
                            if (context.mounted) {
                              context
                                  .read<AppBloc>()
                                  .add(const ChangeNewAccountEvent());
                              Navigator.of(context).pop();
                            }
                          }
                        },
                      )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 98, 96, 1),
                disabledBackgroundColor: Color.fromRGBO(255, 98, 96, .5),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              ),
              child: Text(
                "Add Image",
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(242, 243, 247,
                      state.profileImageToUpload != null ? 1 : .5),
                ),
              ),
            ),
            Gap(MediaQuery.of(context).viewPadding.bottom + 25),
          ],
        );
      },
    );
  }
}
