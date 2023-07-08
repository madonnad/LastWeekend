import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController? email =
        context.read<AuthCubit>().state.emailController;
    final TextEditingController? password =
        context.read<AuthCubit>().state.passwordController;
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          (previous.emailValid != current.emailValid ||
              previous.passwordValid != current.passwordValid),
      builder: (context, state) {
        return state.isLoading == true
            ? const CircularProgressIndicator(
                backgroundColor: Color.fromARGB(35, 0, 0, 0),
              )
            : ElevatedButton(
                onPressed: (state.emailValid == true &&
                        state.passwordValid == true &&
                        email != null &&
                        password != null)
                    ? () => context.read<AuthCubit>().loginWithCredentials(
                        email: email.text, password: password.text)
                    : null,
                child: const Text('Login'),
              );
      },
    );
  }
}
