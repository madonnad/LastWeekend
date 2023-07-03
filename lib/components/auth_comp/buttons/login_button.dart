import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController email;
  final TextEditingController password;
  const LoginButton({required this.email, required this.password, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          (previous.emailMatch != current.emailMatch ||
              previous.passwordMatch != current.passwordMatch),
      builder: (context, state) {
        return state.isLoading == true
            ? const CircularProgressIndicator(
                backgroundColor: Color.fromARGB(35, 0, 0, 0),
              )
            : ElevatedButton(
                onPressed:
                    (state.emailMatch == true && state.passwordMatch == true)
                        ? () => context.read<LoginCubit>().loginWithCredentials(
                            email: email.text, password: password.text)
                        : null,
                child: const Text('Login'),
              );
      },
    );
  }
}
