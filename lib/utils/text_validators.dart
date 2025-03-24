import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/cubit/auth_cubit.dart';

String? checkFirstNameField(String? value, {required BuildContext context}) {
  if (value == null) {
    context.read<AuthCubit>().setFirstNameValid(false);
    return null;
  } else if (value.isNotEmpty) {
    context.read<AuthCubit>().setFirstNameValid(true);
    return null;
  } else if (value.isEmpty) {
    context.read<AuthCubit>().setFirstNameValid(false);
    return null;
  }
  context.read<AuthCubit>().setFirstNameValid(false);
  return null;
}

String? checkLastNameField(String? value, {required BuildContext context}) {
  if (value == null) {
    context.read<AuthCubit>().setLastNameValid(false);
    return null;
  } else if (value.isNotEmpty) {
    context.read<AuthCubit>().setLastNameValid(true);
    return null;
  } else if (value.isEmpty) {
    context.read<AuthCubit>().setLastNameValid(false);
    return null;
  }
  context.read<AuthCubit>().setLastNameValid(false);
  return null;
}

String? checkEmailField(String? value, {required BuildContext context}) {
  if (value == null) {
    context.read<AuthCubit>().setEmailValid(false);
    return null;
  } else if (value.isNotEmpty) {
    RegExp exp = RegExp(
        r'^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$');

    exp.hasMatch(value) ? context.read<AuthCubit>().setEmailValid(true) : null;

    return exp.hasMatch(value) ? null : 'Invalid Email';
  } else if (value.isEmpty) {
    context.read<AuthCubit>().setEmailValid(false);
    return null;
  }
  context.read<AuthCubit>().setEmailValid(false);
  return null;
}

String? checkPasswordField(String? value, {required BuildContext context}) {
  if (value == null) {
    context.read<AuthCubit>().setPasswordValid(false);
    return null;
  } else if (value.isNotEmpty) {
    RegExp exp = RegExp(
        r'^(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[!@#$%^&*a-zA-Z\d]{8,}$');
    //RegExp exp = RegExp(r'^[a-zA-Z]\w{3,14}$');

    exp.hasMatch(value)
        ? context.read<AuthCubit>().setPasswordValid(true)
        : null;

    return exp.hasMatch(value) ? null : 'Invalid Password';
  } else if (value.isEmpty) {
    context.read<AuthCubit>().setPasswordValid(false);
    return null;
  }
  context.read<AuthCubit>().setPasswordValid(false);
  return null;
}

String? checkPasswordConfirmField(
  String? value, {
  required BuildContext context,
  required TextEditingController? password,
}) {
  if (value == null) {
    context.read<AuthCubit>().setConfirmPassValid(false);
    return null;
  } else if (value.isNotEmpty && password != null) {
    value == password.text
        ? context.read<AuthCubit>().setConfirmPassValid(true)
        : null;

    return value == password.text ? null : "Passwords don't match";
  } else if (value.isEmpty) {
    context.read<AuthCubit>().setConfirmPassValid(false);
    return null;
  }
  context.read<AuthCubit>().setConfirmPassValid(false);
  return null;
}

String? emailValidator(String? value) {
  if (value != null || value!.isNotEmpty) {
    RegExp exp = RegExp(r'^^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return exp.hasMatch(value) ? null : 'Invalid Email';
  } else {
    return null;
  }
}

String? loginEmailValidator(String? value) {
  if (value != null || value!.isNotEmpty) {
    RegExp exp = RegExp(r'^^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return exp.hasMatch(value) ? null : 'Invalid Email';
  } else {
    return null;
  }
}

String? loginPassValidator(String? value) {
  if (value != null || value!.isNotEmpty) {
    return value.length >= 8 ? null : 'Invalid password';
  } else {
    return null;
  }
}

String? passValidator(String? value) {
  if (value != null || value!.isNotEmpty) {
    RegExp exp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=(.*\d|.*[!@#\$%^&*]))[a-zA-Z\d!@#\$%^&*]{8,}$');
    //RegExp exp = RegExp(r'^[a-zA-Z]\w{3,14}$');

    return exp.hasMatch(value) ? null : 'Invalid password';
  } else {
    return null;
  }
}

String? passConfirmValidator(String? value, {required String password}) {
  if (value != null || value!.isNotEmpty) {
    RegExp exp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=(.*\d|.*[!@#\$%^&*]))[a-zA-Z\d!@#\$%^&*]{8,}$');

    bool valid = exp.hasMatch(value) && password == value;

    return valid ? null : "Passwords don't match";
  } else {
    return null;
  }
}

String? firstValidator(String? value) {
  if (value != null || value!.isNotEmpty) {
    RegExp exp = RegExp(r"^[A-Za-z][A-Za-z' -]*[A-Za-z]$");
    return exp.hasMatch(value) ? null : "Enter a valid first name";
  } else {
    return null;
  }
}

String? lastValidator(String? value) {
  if (value != null || value!.isNotEmpty) {
    RegExp exp = RegExp(r"^[A-Za-z][A-Za-z' -]*[A-Za-z]$");
    return exp.hasMatch(value) ? null : "Enter a valid last name";
  } else {
    return null;
  }
}
