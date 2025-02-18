import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';

class NewAuth extends StatelessWidget {
  const NewAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(context.read<Auth0Repository>()),
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
            backgroundColor: Color.fromRGBO(19, 19, 20, 1),
            body: SafeArea(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacer(),
                    const StandardLogo(fontSize: 35),
                    Spacer(flex: 2),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white12,
                            blurRadius: 50.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "lib/assets/logo.png",
                        height: 125,
                      ),
                    ),
                    Spacer(flex: 3),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                            "/auth/login",
                            arguments: context.read<AuthCubit>(),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(255, 98, 96, 1),
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 35),
                          ),
                          child: Text(
                            "Login",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(242, 243, 247, 1),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pushNamed(
                            "/auth/sign-up",
                            arguments: context.read<AuthCubit>(),
                          ),
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color.fromRGBO(242, 243, 247, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
