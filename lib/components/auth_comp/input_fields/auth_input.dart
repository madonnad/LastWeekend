import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final String label;
  final TextEditingController? nameController;
  final String? Function(String?)? validator;

  const AuthInput(
      {required this.label,
      required this.nameController,
      this.validator,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      autovalidateMode: AutovalidateMode.always,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }
}
