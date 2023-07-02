import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';
import 'package:shared_photo/components/auth_comp/login_button.dart';
import 'package:shared_photo/components/auth_comp/password_input.dart';

import 'email_input.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication error'),
              ),
            );
        }
      },
      child: const Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmailInput(),
              PasswordInput(),
              LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
