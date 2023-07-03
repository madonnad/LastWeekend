import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController? emailController =
        context.read<LoginCubit>().state.emailController;
    return TextFormField(
      controller: emailController,
      autovalidateMode: AutovalidateMode.always,
      // ignore: body_might_complete_normally_nullable
      validator: (value) {
        if (value == null) {
          context.read<LoginCubit>().setEmailValid(false);
          return null;
        } else if (value.isNotEmpty) {
          RegExp exp = RegExp(
              r'^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$');

          exp.hasMatch(value)
              ? context.read<LoginCubit>().setEmailValid(true)
              : null;

          return exp.hasMatch(value) ? null : 'Invalid Email';
        } else if (value.isEmpty) {
          context.read<LoginCubit>().setEmailValid(false);
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
    );
  }
}
