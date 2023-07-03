import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';

class ConfirmPasswordInput extends StatelessWidget {
  final TextEditingController confirmPasswordController;
  final String password;
  const ConfirmPasswordInput(
      {required this.confirmPasswordController,
      required this.password,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: confirmPasswordController,
      autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        if (value == null) {
          context.read<LoginCubit>().setConfirmPassValid(false);
          return null;
        } else if (value.isNotEmpty) {
          value == password
              ? context.read<LoginCubit>().setConfirmPassValid(true)
              : null;

          return value == password ? null : "Passwords don't match";
        } else if (value.isEmpty) {
          context.read<LoginCubit>().setConfirmPassValid(false);
          return null;
        }
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: const InputDecoration(
        labelText: 'Confirm Password',
      ),
    );
  }
}
