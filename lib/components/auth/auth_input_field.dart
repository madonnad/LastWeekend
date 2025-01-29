import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthInputField extends StatefulWidget {
  final String hintText;
  final TextEditingController? nameController;
  final String? Function(String?)? validator;
  final bool showTextVisToggle;
  final Iterable<String>? autofillHints;
  const AuthInputField(
      {super.key,
      required this.hintText,
      required this.nameController,
      this.showTextVisToggle = false,
      this.autofillHints,
      this.validator});

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  late bool obscureText;
  IconData icon = Icons.visibility;

  @override
  void initState() {
    if (widget.showTextVisToggle) {
      obscureText = true;
    } else {
      obscureText = false;
    }
    super.initState();
  }

  void toggleTextObscuring() {
    setState(() {
      obscureText = !obscureText;
      if (obscureText) {
        icon = Icons.visibility;
      } else {
        icon = Icons.visibility_off_outlined;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      child: TextFormField(
        controller: widget.nameController,
        autovalidateMode: AutovalidateMode.always,
        autofillHints: widget.autofillHints,
        validator: widget.validator,
        obscureText: obscureText,
        keyboardType: TextInputType.emailAddress,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
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
          suffixIcon: widget.showTextVisToggle == true
              ? GestureDetector(
                  child: Icon(icon),
                  onTap: () => toggleTextObscuring(),
                )
              : null,
          suffixIconColor: const Color.fromRGBO(108, 108, 108, 1),
        ),
      ),
    );
  }
}
