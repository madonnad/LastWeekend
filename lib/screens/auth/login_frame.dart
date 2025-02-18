import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/auth/forgot_password.dart';
import 'package:shared_photo/components/new_auth/auth_text_field.dart';
import 'package:shared_photo/utils/text_validators.dart';

class LoginFrame extends StatefulWidget {
  const LoginFrame({super.key});

  @override
  State<LoginFrame> createState() => _LoginFrameState();
}

class _LoginFrameState extends State<LoginFrame> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passKey = GlobalKey<FormFieldState>();
  bool emailValid = false;
  bool passValid = false;

  void setEmail() {
    setState(() {
      emailValid = _emailKey.currentState?.isValid ?? false;
    });
  }

  void setPass() {
    setState(() {
      passValid = _passKey.currentState?.isValid ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current.exception.errorString != null,
      listener: (context, state) {
        String errorString = "${state.exception.errorString} ";
        SnackBar snackBar = SnackBar(
          backgroundColor: const Color.fromRGBO(34, 34, 38, 1),
          content: Text(errorString),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Color.fromRGBO(19, 19, 20, 1),
              resizeToAvoidBottomInset: true,
              //extendBody: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(242, 243, 247, 1),
                  ),
                ),
                title: Image.asset("lib/assets/logo.png", height: 40),
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    children: [
                      Gap(15),
                      Center(
                        child: Text(
                          "Login to account",
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(242, 243, 247, 1),
                          ),
                        ),
                      ),
                      Gap(15),
                      Form(
                        key: _formKey,
                        child: AutofillGroup(
                          child: Column(
                            children: [
                              AuthTextField(
                                uniqueKey: _emailKey,
                                hintText: "Email",
                                controller: emailController,
                                validator: (value) =>
                                    loginEmailValidator(value),
                                onChanged: (value) => setEmail(),
                                showTextVisToggle: false,
                                autofillHints: [AutofillHints.email],
                              ),
                              Gap(15),
                              AuthTextField(
                                uniqueKey: _passKey,
                                hintText: "Password",
                                controller: passController,
                                validator: (value) => loginPassValidator(value),
                                onChanged: (value) => setPass(),
                                showTextVisToggle: true,
                                autofillHints: [AutofillHints.password],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (ctx) => BlocProvider.value(
                              value: context.read<AuthCubit>(),
                              child: const ForgotPassword(),
                            ),
                          ),
                          child: Text("Forgot password?"),
                        ),
                      ),
                      //Gap(5),
                      ElevatedButton(
                        onPressed: (emailValid && passValid)
                            ? () async {
                                await context
                                    .read<AuthCubit>()
                                    .loginWithCredentials(
                                        email: emailController.text,
                                        password: passController.text)
                                    .then((_) =>
                                        TextInput.finishAutofillContext());
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 98, 96, 1),
                          disabledBackgroundColor:
                              Color.fromRGBO(255, 98, 96, .5),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.lato(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(242, 243, 247,
                                ((emailValid && passValid) ? 1 : .5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            state.isLoading
                ? Container(
                    color: Colors.black.withAlpha(125),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(255, 98, 96, 1),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
