import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordInput({required this.passwordController, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      autovalidateMode: AutovalidateMode.always,
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (value == null) {
          context.read<LoginCubit>().setPasswordValid(false);
          return null;
        } else if (value.isNotEmpty) {
          RegExp exp = RegExp(r'^[a-zA-Z]\w{3,14}$');

          exp.hasMatch(value)
              ? context.read<LoginCubit>().setPasswordValid(true)
              : null;

          return exp.hasMatch(value) ? null : 'Invalid Password';
        } else if (value.isEmpty) {
          context.read<LoginCubit>().setPasswordValid(false);
          return null;
        }
      },
      keyboardType: TextInputType.visiblePassword,
      decoration: const InputDecoration(
        labelText: 'Create Password',
      ),
    );
  }
}
