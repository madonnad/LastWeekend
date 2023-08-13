import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          (previous.emailValid != current.emailValid ||
              previous.passwordValid != current.passwordValid ||
              current.isLoading == true),
      builder: (context, state) {
        return state.isLoading == true
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  backgroundColor: Color.fromARGB(35, 0, 0, 0),
                ),
              )
            : ElevatedButton(
                onPressed: (state.emailValid == true &&
                        state.passwordValid == true &&
                        state.isLoading != true)
                    ? () => context.read<AuthCubit>().loginWithCredentials(
                        email: state.emailController!.text,
                        password: state.passwordController!.text)
                    : null,
                child: const Text('Login'),
              );
      },
    );
  }
}
