import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/login_cubit.dart';
import 'package:shared_photo/components/auth_comp/create_account_form.dart';
import 'package:shared_photo/components/auth_comp/login_form.dart';
import 'package:shared_photo/repositories/authentication_repository.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(
          context.read<AuthenticationRepository>(),
        ),
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (!state.accountCreateMode)
                      ? LoginForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                        )
                      : CreateAccountForm(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
