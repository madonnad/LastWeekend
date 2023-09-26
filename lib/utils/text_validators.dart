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
