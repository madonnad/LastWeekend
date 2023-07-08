import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/auth_comp/input_fields/auth_input.dart';
import 'package:shared_photo/utils/text_validators.dart';
import '../buttons/create_account_button.dart';
import '../buttons/login_textspan.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.errorMessage != '') {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Authentication error',
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AuthInput(
                  label: 'Enter Email',
                  nameController: state.emailController,
                  validator: (value) =>
                      checkEmailField(value, context: context),
                ),
                AuthInput(
                  label: 'Create Password',
                  nameController: state.passwordController,
                  validator: (value) =>
                      checkPasswordField(context: context, value),
                ),
                AuthInput(
                  label: 'Confirm Password',
                  nameController: state.confirmPassController,
                  validator: (value) => checkPasswordConfirmField(
                    value,
                    context: context,
                    password: state.passwordController,
                  ),
                ),
                AuthInput(
                  label: 'First Name',
                  nameController: state.firstNameController,
                  validator: (value) =>
                      checkFirstNameField(context: context, value),
                ),
                AuthInput(
                  label: 'Last Name',
                  nameController: state.lastNameController,
                  validator: (value) =>
                      checkLastNameField(context: context, value),
                ),
                const CreateAccountButton(),
                const LoginTextSpan()
              ],
            ),
          ),
        );
      },
    );
  }
}
