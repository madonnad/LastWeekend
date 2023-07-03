import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';
import 'package:shared_photo/components/auth_comp/login_button.dart';
import 'package:shared_photo/components/auth_comp/password_input.dart';

import 'email_input.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication error'),
              ),
            );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmailInput(emailController: _emailController),
              PasswordInput(passwordController: _passwordController),
              LoginButton(
                email: _emailController,
                password: _passwordController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
