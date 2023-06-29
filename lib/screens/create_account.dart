import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit_app.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(65, 68, 75, 100),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'dvlpr',
              style: GoogleFonts.josefinSlab(
                color: const Color.fromRGBO(251, 250, 205, 100),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            AuthInputTextField(
              hintText: 'email password',
              controller: _emailController,
              obscuredText: false,
            ),
            AuthInputTextField(
              hintText: 'password',
              controller: _passwordController,
              obscuredText: true,
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  BlocProvider.of<AuthCubitApp>(context).registerNewEmailUser(
                    _emailController.text,
                    _passwordController.text,
                  );
                  Navigator.of(context).pushNamed('/add_personal_info');
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
                'create account',
                style: GoogleFonts.josefinSlab(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.josefinSlab(
                    color: const Color.fromRGBO(193, 239, 255, 100),
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: 'i have an account! '),
                    TextSpan(
                      text: 'login here',
                      style: GoogleFonts.josefinSlab(
                        color: const Color.fromRGBO(193, 239, 255, 100),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          BlocProvider.of<AuthCubitApp>(context)
                              .goToLoginScreen();
                        },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AuthInputTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscuredText;
  const AuthInputTextField(
      {required this.hintText,
      required this.controller,
      required this.obscuredText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscuredText,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromRGBO(82, 87, 93, 100),
          hintText: hintText,
          hintStyle: GoogleFonts.josefinSlab(
            fontSize: 20,
            color: Colors.white60,
            fontWeight: FontWeight.normal,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide(
              color: Color.fromRGBO(193, 239, 255, 100),
            ),
          ),
        ),
        style: GoogleFonts.josefinSlab(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
