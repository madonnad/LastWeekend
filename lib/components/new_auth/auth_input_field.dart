import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController? nameController;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  const AuthInputField(
      {super.key,
      required this.hintText,
      required this.nameController,
      this.autofillHints,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: TextFormField(
        controller: nameController,
        autovalidateMode: AutovalidateMode.always,
        autofillHints: autofillHints,
        validator: validator,
        keyboardType: TextInputType.emailAddress,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color.fromRGBO(108, 108, 108, 1),
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color.fromRGBO(108, 108, 108, 1),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(44, 44, 44, 1),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: Color.fromRGBO(95, 95, 95, 1),
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
