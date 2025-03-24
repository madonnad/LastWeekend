import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/new_auth/auth_text_field.dart';
import 'package:shared_photo/utils/text_validators.dart';

class PersonalPage extends StatefulWidget {
  final PageController controller;
  final TextEditingController firstController;
  final TextEditingController lastController;
  final TextEditingController emailController;
  final TextEditingController passController;
  const PersonalPage({
    super.key,
    required this.firstController,
    required this.lastController,
    required this.controller,
    required this.emailController,
    required this.passController,
  });

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstKey = GlobalKey<FormFieldState>();
  final _lastKey = GlobalKey<FormFieldState>();
  bool firstValid = false;
  bool lastValid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      firstSet();
      lastSet();
    });
  }

  void firstSet() {
    setState(() {
      firstValid = _firstKey.currentState?.isValid ?? false;
    });
  }

  void lastSet() {
    setState(() {
      lastValid = _lastKey.currentState?.isValid ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Personal information",
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
              child: Column(
                children: [
                  AuthTextField(
                    uniqueKey: _firstKey,
                    hintText: "Enter first name",
                    controller: widget.firstController,
                    validator: (value) => firstValidator(value),
                    onChanged: (value) => firstSet(),
                    showTextVisToggle: false,
                  ),
                  Gap(15),
                  AuthTextField(
                    uniqueKey: _lastKey,
                    hintText: "Enter last name",
                    controller: widget.lastController,
                    validator: (value) => lastValidator(value),
                    onChanged: (value) => lastSet(),
                    showTextVisToggle: false,
                  ),
                ],
              ),
            ),
            Gap(15),
            Center(
              child: ElevatedButton(
                onPressed: (firstValid && lastValid)
                    ? () async {
                        TextInput.finishAutofillContext();
                        await context
                            .read<AuthCubit>()
                            .createAccountWithCredentials(
                              email: widget.emailController.text,
                              password: widget.passController.text,
                              firstName: widget.firstController.text,
                              lastName: widget.lastController.text,
                            )
                            .then((_) => TextInput.finishAutofillContext());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(255, 98, 96, 1),
                  disabledBackgroundColor: Color.fromRGBO(255, 98, 96, .5),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                ),
                child: Text(
                  "Create Account",
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(
                        242, 243, 247, (firstValid && lastValid) ? 1 : .5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
