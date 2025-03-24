import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/new_auth/account_info/pass_quality.dart';
import 'package:shared_photo/components/new_auth/auth_text_field.dart';
import 'package:shared_photo/utils/text_validators.dart';

class AccountPage extends StatefulWidget {
  final PageController controller;
  final TextEditingController emailController;
  final TextEditingController passController;
  final TextEditingController passConfirmController;
  const AccountPage({
    super.key,
    required this.controller,
    required this.emailController,
    required this.passController,
    required this.passConfirmController,
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passKey = GlobalKey<FormFieldState>();
  final _confirmKey = GlobalKey<FormFieldState>();
  bool emailValid = false;
  bool passValid = false;
  bool confirmValid = false;
  bool uppercase = false;
  bool lowercase = false;
  bool charOrDig = false;
  bool length = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      emailSet();
      passSet();
      confirmSet();
    });
  }

  void emailSet() {
    setState(() {
      emailValid = _emailKey.currentState?.isValid ?? false;
    });
  }

  void passSet() {
    String password = widget.passController.text;
    setState(() {
      passValid = _passKey.currentState?.isValid ?? false;
      if (widget.passConfirmController.text != '') {
        confirmValid = _confirmKey.currentState?.isValid ?? false;
      }
      uppercase = RegExp(r'[A-Z]').hasMatch(password);
      lowercase = RegExp(r'[a-z]').hasMatch(password);
      charOrDig = RegExp(r'[!@#$%^&*]').hasMatch(password) ||
          RegExp(r'[0-9]').hasMatch(password);
      length = password.length >= 8;
    });
  }

  void confirmSet() {
    setState(() {
      confirmValid = _confirmKey.currentState?.isValid ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Center(
              child: Text(
                "Account information",
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
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      AuthTextField(
                        uniqueKey: _emailKey,
                        hintText: "Enter email",
                        controller: widget.emailController,
                        validator: (value) => emailValidator(value),
                        onChanged: (value) => emailSet(),
                        showTextVisToggle: false,
                        autofillHints: [AutofillHints.email],
                      ),
                      Gap(15),
                      AuthTextField(
                        uniqueKey: _passKey,
                        hintText: "Choose password",
                        controller: widget.passController,
                        validator: (value) => passValidator(value),
                        onChanged: (value) => passSet(),
                        showTextVisToggle: true,
                        autofillHints: [AutofillHints.newPassword],
                      ),
                      Gap(15),
                      PassQuality(
                        uppercase: uppercase,
                        lowercase: lowercase,
                        charOrDig: charOrDig,
                        length: length,
                      ),
                      Gap(15),
                      AuthTextField(
                        uniqueKey: _confirmKey,
                        hintText: "Confirm password",
                        controller: widget.passConfirmController,
                        validator: (value) => passConfirmValidator(
                          value,
                          password: widget.passController.text,
                        ),
                        onChanged: (value) => confirmSet(),
                        showTextVisToggle: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap(15),
            ElevatedButton(
              onPressed: (emailValid && passValid && confirmValid)
                  ? () {
                      if (_formKey.currentState != null) {
                        _formKey.currentState!.save();
                      }
                      widget.controller.nextPage(
                        duration: Durations.medium1,
                        curve: Curves.linear,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 98, 96, 1),
                disabledBackgroundColor: Color.fromRGBO(255, 98, 96, .5),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              ),
              child: Text(
                "Continue",
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(242, 243, 247,
                      (emailValid && passValid && confirmValid) ? 1 : .5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;
}
