import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          (previous.emailValid != current.emailValid ||
              previous.passwordValid != current.passwordValid ||
              previous.confirmPassValid != current.confirmPassValid ||
              previous.firstNameValid != current.firstNameValid ||
              previous.lastNameValid != current.lastNameValid),
      builder: (context, state) {
        return state.isLoading == true
            ? const CircularProgressIndicator(
                backgroundColor: Color.fromARGB(35, 0, 0, 0),
              )
            : ElevatedButton(
                onPressed: (state.emailValid == true &&
                        state.passwordValid == true &&
                        state.confirmPassValid == true &&
                        state.firstNameValid == true &&
                        state.lastNameValid == true)
                    ? () => context
                        .read<AuthCubit>()
                        .createAccountWithCredentials(
                            email: state.emailController!.text,
                            password: state.emailController!.text)
                    : null,
                child: const Text('Create Account'),
              );
      },
    );
  }
}
