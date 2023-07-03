import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';

class ConfirmPasswordInput extends StatelessWidget {
  const ConfirmPasswordInput({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController? password =
        context.read<LoginCubit>().state.passwordController;
    final TextEditingController? confirmPassController =
        context.read<LoginCubit>().state.confirmPassController;
    return TextFormField(
      controller: confirmPassController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (value == null) {
          context.read<LoginCubit>().setConfirmPassValid(false);
          return null;
        } else if (value.isNotEmpty && password != null) {
          value == password.text
              ? context.read<LoginCubit>().setConfirmPassValid(true)
              : null;

          return value == password.text ? null : "Passwords don't match";
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
