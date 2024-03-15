import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/new_auth/auth_input_field.dart';
import 'package:shared_photo/utils/text_validators.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            AuthInputField(
              hintText: "Email",
              validator: (value) => checkEmailField(value, context: context),
              nameController: state.emailController,
            ),
            const SizedBox(height: 15),
            AuthInputField(
              hintText: "Password",
              nameController: state.passwordController,
              validator: (value) => checkPasswordField(context: context, value),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom * .4),
              child: Text(
                "Forgot password?",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(108, 108, 108, 1),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
