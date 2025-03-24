import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';
import 'package:shared_photo/utils/text_validators.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();
    return PageView(
      controller: controller,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SimpleDialog(
          backgroundColor: const Color.fromRGBO(19, 19, 20, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Forgot Password?",
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  color: Color.fromRGBO(242, 243, 247, 1),
                ),
              ),
            ],
          ),
          titleTextStyle: GoogleFonts.lato(
            color: Color.fromRGBO(242, 243, 247, 1),
            fontWeight: FontWeight.w600,
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                "To recover your password enter your email below and if it exists a link will be sent to recover your password.",
                style: GoogleFonts.lato(
                  color: Color.fromRGBO(242, 243, 247, .85),
                ),
              ),
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return SimpleDialogOption(
                  child: TextFormField(
                    controller: state.emailController,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      String? result = checkEmailField(value, context: context);

                      if (result == "Invalid Email") {
                        context.read<AuthCubit>().setEmailValid(false);
                      }
                      return result;
                    },
                    decoration: InputDecoration(
                      fillColor: const Color.fromRGBO(34, 34, 38, 1),
                      filled: true,
                      hintText: "Enter email",
                      hintStyle: GoogleFonts.lato(
                        color: Colors.white54,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: GoogleFonts.lato(
                      color: Color.fromRGBO(242, 243, 247, 1),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return SimpleDialogOption(
                  child: TextButton(
                    onPressed: state.emailValid
                        ? () {
                            context.read<Auth0Repository>().resetPassword(
                                email: state.emailController!.text);
                            controller.animateToPage(1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.linear);
                          }
                        : null,
                    statesController: WidgetStatesController(),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateColor.resolveWith(getButtonColor),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: Text(
                      "Submit",
                      style: GoogleFonts.lato(
                        color: state.emailValid
                            ? Color.fromRGBO(242, 243, 247, 1)
                            : Color.fromRGBO(242, 243, 247, .5),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        SimpleDialog(
          backgroundColor: const Color.fromRGBO(19, 19, 20, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            "Forgot Password?",
          ),
          titleTextStyle: GoogleFonts.lato(
            color: Color.fromRGBO(242, 243, 247, 1),
            fontWeight: FontWeight.w600,
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                "If an account with that email exists an email will be sent.",
                style: GoogleFonts.lato(
                  color: Color.fromRGBO(242, 243, 247, .85),
                ),
              ),
            ),
            SimpleDialogOption(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                statesController: WidgetStatesController(),
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(getButtonColor),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  "Close",
                  style: GoogleFonts.lato(
                    color: Color.fromRGBO(242, 243, 247, 1),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Color getButtonColor(Set<WidgetState> state) {
  if (state.contains(WidgetState.disabled)) {
    return const Color.fromRGBO(255, 98, 96, .5);
  }
  return const Color.fromRGBO(255, 98, 96, 1);
}
