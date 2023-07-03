import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController passwordController;
  const PasswordInput({required this.passwordController, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          controller: passwordController,
          onChanged: (password) =>
              context.read<LoginCubit>().passwordChanged(password),
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            labelText: 'Password',
          ),
        );
      },
    );
  }
}
