import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit_app.dart';

class CreateAccountPersonalInfoScreen extends StatelessWidget {
  CreateAccountPersonalInfoScreen({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tell us about yourself!',
            ),
            const SizedBox(
              height: 25,
            ),
            Form(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
                    child: AccountFormField(
                      fieldName: 'First Name',
                      controller: _firstNameController,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
                    child: AccountFormField(
                      fieldName: 'Last Name',
                      controller: _lastNameController,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, String?> personalInfoPayload = {
                        'firstName': _firstNameController.text,
                        'lastName': _lastNameController.text
                      };
                      try {
                        BlocProvider.of<AuthCubitApp>(context)
                            .addPersonalInfoToDB(personalInfoPayload);
                        Navigator.of(context)
                            .pushReplacementNamed('/add_profile_pic');
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(251, 250, 205, 100),
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'continue',
                      style: GoogleFonts.josefinSlab(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AccountFormField extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;
  const AccountFormField(
      {super.key, required this.fieldName, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.amber,
      decoration: InputDecoration(
        hintText: fieldName,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
