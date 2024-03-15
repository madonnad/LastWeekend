import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/new_auth/auth_input_field.dart';
import 'package:shared_photo/utils/text_validators.dart';

class CreateAccountForm extends StatelessWidget {
  const CreateAccountForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            AuthInputField(
              hintText: "First Name",
              nameController: state.firstNameController,
              validator: (value) =>
                  checkFirstNameField(context: context, value),
            ),
            const SizedBox(height: 15),
            AuthInputField(
              hintText: "Last Name",
              nameController: state.lastNameController,
              validator: (value) => checkLastNameField(context: context, value),
            ),
            const SizedBox(height: 15),
            AuthInputField(
              hintText: "Email",
              validator: (value) => checkEmailField(value, context: context),
              nameController: state.emailController,
            ),
            const SizedBox(height: 15),
            AuthInputField(
              hintText: "Password",
              nameController: state.passwordController,
              validator: (value) => checkPasswordField(context: context, value),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom * .6),
              child: AuthInputField(
                hintText: "Confirm Password",
                nameController: state.confirmPassController,
                validator: (value) => checkPasswordConfirmField(
                  value,
                  context: context,
                  password: state.passwordController,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
