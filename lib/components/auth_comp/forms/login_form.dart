import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/auth_comp/input_fields/auth_input.dart';
import '../../../utils/text_validators.dart';
import '../buttons/join_textspan.dart';
import '../buttons/login_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != '') {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication error'),
              ),
            );
        }
      },
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AuthInput(
                  label: 'Enter Email',
                  nameController: state.emailController,
                  validator: (value) =>
                      checkEmailField(value, context: context),
                ),
                AuthInput(
                  label: 'Create Password',
                  nameController: state.passwordController,
                  validator: (value) =>
                      checkPasswordField(context: context, value),
                ),
                const LoginButton(),
                const JoinTextSpan()
              ],
            ),
          ),
        );
      },
    );
  }
}
