import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/components/auth/auth_linked_text.dart';
import 'package:shared_photo/components/auth/auth_logic_widgets/login_create_button.dart';
import 'package:shared_photo/components/auth/create_account_form.dart';
import 'package:shared_photo/components/auth/login_form.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';

class AuthFrame extends StatelessWidget {
  const AuthFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        context.read<Auth0Repository>(),
      ),
      child: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) =>
            current.exception.errorString != null,
        listener: (context, state) {
          String errorString = "${state.exception.errorString} ";
          SnackBar snackBar = SnackBar(
            backgroundColor: const Color.fromRGBO(19, 19, 19, 1),
            content: Text(errorString),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(19, 19, 19, 1),
                        Color.fromRGBO(19, 19, 19, 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          const StandardLogo(fontSize: 40),
                          const Spacer(
                            flex: 2,
                          ),
                          AutofillGroup(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Conditionally Show the First Name Field
                                state.accountCreateMode
                                    ? const CreateAccountForm()
                                    : const LoginForm(),
                                // Conditionally Switch Confirm Buttons
                                const LoginCreateButton(),
                                // Conditonally Switch Linked Text
                                state.accountCreateMode
                                    ? AuthLinkedText(
                                        linkText: "Have an account? Login",
                                        onTap: () => context
                                            .read<AuthCubit>()
                                            .swapModes(),
                                      )
                                    : AuthLinkedText(
                                        linkText: "Create account",
                                        onTap: () => context
                                            .read<AuthCubit>()
                                            .swapModes(),
                                      )
                              ],
                            ),
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                  ),
                ),
                state.isLoading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : const SizedBox(
                        height: 0,
                      )
              ],
            ),
          );
        },
      ),
    );
  }
}
