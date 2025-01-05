import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';

class LoginTextSpan extends StatelessWidget {
  const LoginTextSpan({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          const TextSpan(
            text: 'Already a member? ',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: 'Login here',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.read<AuthCubit>().swapModes();
              },
          ),
        ],
      ),
    );
  }
}
