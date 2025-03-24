import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Edit Profile",
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
                    Gap(10),
                    const SectionHeaderSmall("FIRST NAME"),
                    Gap(4),
                    TextField(
                      controller: firstNameController,
                      onChanged: (value) =>
                          context.read<SettingsCubit>().updateFirstName(value),
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: state.user.firstName,
                      ),
                    ),
                    Gap(10),
                    const SectionHeaderSmall("LAST NAME"),
                    Gap(4),
                    TextField(
                      controller: lastNameController,
                      onChanged: (value) =>
                          context.read<SettingsCubit>().updateLastName(value),
                      enabled: true,
                      decoration: InputDecoration(
                        hintText: state.user.lastName,
                      ),
                    ),
                    Gap(10),
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
                        ? Center(
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<SettingsCubit>()
                                    .updateFirstLastName();
                                context
                                    .read<Auth0Repository>()
                                    .getInternalUserInformation(
                                        state.user.token, email, false);
                              },
                              child: Text(
                                "Update",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    Gap(15),
                  ],
                ),
              ),
              state.loading
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black54,
                      child: Center(
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
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.lato(
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
