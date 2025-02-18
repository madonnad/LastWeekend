import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextField extends StatefulWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Function(String?) onChanged;
  final GlobalKey uniqueKey;
  final bool showTextVisToggle;
  final List<String>? autofillHints;
  const AuthTextField({
    super.key,
    required this.hintText,
    required this.validator,
    required this.controller,
    required this.onChanged,
    required this.uniqueKey,
    required this.showTextVisToggle,
    this.autofillHints,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
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
    return TextFormField(
      key: widget.uniqueKey,
      controller: widget.controller,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      onChanged: (value) => widget.onChanged(value),
      validator: widget.validator,
      keyboardType: TextInputType.emailAddress,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      autofillHints: widget.autofillHints,
      style: GoogleFonts.lato(
        color: Color.fromRGBO(242, 243, 247, 1),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(34, 34, 38, 1),
        filled: true,
        hintText: widget.hintText,
        hintStyle: GoogleFonts.lato(
          color: Color.fromRGBO(242, 243, 247, .75),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: widget.showTextVisToggle == true
            ? GestureDetector(
                child: Icon(icon),
                onTap: () => toggleTextObscuring(),
              )
            : null,
        suffixIconColor: const Color.fromRGBO(242, 243, 247, .75),
      ),
    );
  }
}
