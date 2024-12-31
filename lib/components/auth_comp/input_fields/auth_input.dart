import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final String label;
  final TextEditingController? nameController;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHint;

  const AuthInput(
      {required this.label,
      required this.nameController,
      this.validator,
      this.autofillHint,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      autovalidateMode: AutovalidateMode.always,
      autofillHints: autofillHint,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
