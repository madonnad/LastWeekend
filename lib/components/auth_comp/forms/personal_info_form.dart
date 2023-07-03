import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';
import 'package:shared_photo/components/auth_comp/input_fields/confirm_password_input.dart';
import 'package:shared_photo/components/auth_comp/input_fields/password_input.dart';
import 'package:shared_photo/components/auth_comp/buttons/create_account_next.dart';
import '../input_fields/email_input.dart';

class PersonalInfoForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PersonalInfoForm({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != '') {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Authentication error',
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        return const Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                EmailInput(),
                PasswordInput(),
                ConfirmPasswordInput(),
                CreateAccountNext(),
                LoginTextSpan()
              ],
            ),
          ),
        );
      },
    );
  }
}

class LoginTextSpan extends StatelessWidget {
  const LoginTextSpan({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          const TextSpan(
            text: 'Already a member? ',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'Login here',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => context.read<LoginCubit>().swapModes(),
          ),
        ],
      ),
    );
  }
}
