import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';

class CreateAccountNext extends StatelessWidget {
  const CreateAccountNext({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          (previous.emailValid != current.emailValid ||
              previous.passwordValid != current.passwordValid ||
              previous.confirmPassValid != current.confirmPassValid),
      builder: (context, state) {
        return state.isLoading == true
            ? const CircularProgressIndicator(
                backgroundColor: Color.fromARGB(35, 0, 0, 0),
              )
            : ElevatedButton(
                onPressed: (state.emailValid == true &&
                        state.passwordValid == true &&
                        state.confirmPassValid == true)
                    ? () =>
                        Navigator.of(context).pushNamed('/create-account-auth')
                    : null,
                child: const Text('Next'),
              );
      },
    );
  }
}
