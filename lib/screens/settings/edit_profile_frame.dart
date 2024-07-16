import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/settings_cubit.dart';
import 'package:shared_photo/components/app_comp/section_header_small.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';

class EditProfileFrame extends StatelessWidget {
  const EditProfileFrame({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.josefinSans(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          String email = state.user.email ?? '';
          if (state.firstName != null) {
            firstNameController.text = state.firstName!;
          }
          if (state.lastName != null) {
            lastNameController.text = state.lastName!;
          }

          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 15.0,
                  right: 15,
                  bottom: MediaQuery.of(context).viewPadding.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeaderSmall("FIRST NAME"),
                    EditProfileTextField(
                      hintText: state.user.firstName,
                      enabled: true,
                      controller: firstNameController,
                      onChanged: (value) =>
                          context.read<SettingsCubit>().updateFirstName(value),
                    ),
                    const SectionHeaderSmall("LAST NAME"),
                    EditProfileTextField(
                      hintText: state.user.lastName,
                      enabled: true,
                      controller: lastNameController,
                      onChanged: (value) =>
                          context.read<SettingsCubit>().updateLastName(value),
                    ),
                    const SectionHeaderSmall("EMAIL"),
                    EditProfileTextField(
                      hintText: email,
                      enabled: false,
                      controller: TextEditingController(),
                      onChanged: (_) {},
                    ),
                    Flexible(
                      child: Container(),
                    ),
                    !state.nameMatches
                        ? GestureDetector(
                            onTap: () {
                              context
                                  .read<SettingsCubit>()
                                  .updateFirstLastName();
                              context
                                  .read<Auth0Repository>()
                                  .getInternalUserInformation(
                                      state.user.token, email, false);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 75,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
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
                                  borderRadius: BorderRadius.circular(10)),
                              height: 50,
                              child: Center(
                                  child: Text(
                                "Update",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              )),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              state.loading
                  ? Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black54,
                        child: const CircularProgressIndicator.adaptive(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  final String hintText;
  final bool enabled;
  final TextEditingController controller;
  final Function(String) onChanged;
  const EditProfileTextField({
    super.key,
    required this.hintText,
    required this.enabled,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        enabled: enabled,
        controller: controller,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(108, 108, 108, enabled ? 1 : .5),
          ),
          filled: true,
          fillColor: enabled
              ? const Color.fromRGBO(44, 44, 44, 1)
              : const Color.fromRGBO(19, 19, 19, 1),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Color.fromRGBO(95, 95, 95, 1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Color.fromRGBO(19, 19, 19, 1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Color.fromRGBO(158, 158, 158, 1),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
