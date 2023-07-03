import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';

class CreateAccountButton extends StatelessWidget {
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirmPass;
  const CreateAccountButton(
      {required this.email,
      required this.password,
      required this.confirmPass,
      super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          (previous.emailMatch != current.emailMatch ||
              previous.passwordMatch != current.passwordMatch ||
              previous.confirmPassMatch != current.confirmPassMatch),
      builder: (context, state) {
        return state.isLoading == true
            ? const CircularProgressIndicator(
                backgroundColor: Color.fromARGB(35, 0, 0, 0),
              )
            : ElevatedButton(
                onPressed: (state.emailMatch == true &&
                        state.passwordMatch == true &&
                        state.confirmPassMatch == true)
                    ? () => context
                        .read<LoginCubit>()
                        .createAccountWithCredentials(
                            email: email.text, password: password.text)
                    : null,
                child: const Text('Create Account'),
              );
      },
    );
  }
}
