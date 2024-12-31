import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/new_auth/confirm_button.dart';

class LoginCreateButton extends StatelessWidget {
  const LoginCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          (previous.emailValid != current.emailValid ||
              previous.passwordValid != current.passwordValid ||
              previous.confirmPassValid != current.confirmPassValid ||
              previous.firstNameValid != current.firstNameValid ||
              previous.lastNameValid != current.lastNameValid ||
              previous.accountCreateMode != current.accountCreateMode),
      builder: (context, state) => state.accountCreateMode
          ? Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: ConfirmButton(
                buttonText: "Create Account",
                onTap: state.isLoading == false
                    ? (state.emailValid == true &&
                            state.passwordValid == true &&
                            state.confirmPassValid == true &&
                            state.firstNameValid == true &&
                            state.lastNameValid == true)
                        ? () {
                            TextInput.finishAutofillContext(
                              shouldSave: true,
                            );
                            context
                                .read<AuthCubit>()
                                .createAccountWithCredentials(
                                    email: state.emailController!.text,
                                    password: state.passwordController!.text,
                                    firstName: state.firstNameController!.text,
                                    lastName: state.lastNameController!.text);
                          }
                        : null
                    : null,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: ConfirmButton(
                buttonText: "Login",
                onTap: state.isLoading == false
                    ? (state.emailValid == true && state.passwordValid == true)
                        ? () {
                            context.read<AuthCubit>().loginWithCredentials(
                                email: state.emailController!.text,
                                password: state.passwordController!.text);
                          }
                        : null
                    : null,
              ),
            ),
    );
  }
}
