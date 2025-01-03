import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/new_auth/auth_input_field.dart';
import 'package:shared_photo/components/new_auth/forgot_password.dart';
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
              autofillHints: [AutofillHints.email],
              validator: (value) {
                String? result = checkEmailField(value, context: context);

                if (result == "Invalid Email") {
                  context.read<AuthCubit>().setEmailValid(false);
                }
                return result;
              },
              nameController: state.emailController,
            ),
            const SizedBox(height: 15),
            AuthInputField(
              hintText: "Password",
              nameController: state.passwordController,
              autofillHints: [AutofillHints.password],
              validator: (value) {
                String? result = checkPasswordField(value, context: context);

                if (result == "Invalid Password") {
                  context.read<AuthCubit>().setPasswordValid(false);
                }
                return result;
              },
              showTextVisToggle: true,
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (ctx) => BlocProvider.value(
                  value: context.read<AuthCubit>(),
                  child: const ForgotPassword(),
                ),
              ),
              child: Padding(
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
            ),
          ],
        );
      },
    );
  }
}
