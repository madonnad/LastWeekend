import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/auth_comp/forms/create_account_form.dart';
import 'package:shared_photo/components/auth_comp/forms/login_form.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AuthCubit(
          context.read<AuthenticationRepository>(),
        ),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (!state.accountCreateMode)
                      ? const LoginForm()
                      : const CreateAccountForm(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
