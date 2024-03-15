import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/repositories/auth0_repository.dart';

class AuthFrame extends StatelessWidget {
  const AuthFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        context.read<Auth0Repository>(),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.black,
            body: Container(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          state.accountCreateMode
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: TextField(
                                    onTapOutside: (event) => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                          108, 108, 108, 1),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "First Name",
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                            108, 108, 108, 1),
                                      ),
                                      filled: true,
                                      fillColor:
                                          const Color.fromRGBO(44, 44, 44, 1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: Color.fromRGBO(95, 95, 95, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(158, 158, 158, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 0,
                                ),
                          const SizedBox(height: 15),
                          state.accountCreateMode
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: TextField(
                                    onTapOutside: (event) => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                          108, 108, 108, 1),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Last Name",
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                            108, 108, 108, 1),
                                      ),
                                      filled: true,
                                      fillColor:
                                          const Color.fromRGBO(44, 44, 44, 1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: Color.fromRGBO(95, 95, 95, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(158, 158, 158, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 0,
                                ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(108, 108, 108, 1),
                              ),
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                ),
                                filled: true,
                                fillColor: const Color.fromRGBO(44, 44, 44, 1),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(95, 95, 95, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(158, 158, 158, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            child: TextField(
                              onTapOutside: (event) =>
                                  FocusManager.instance.primaryFocus?.unfocus(),
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(108, 108, 108, 1),
                              ),
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color.fromRGBO(108, 108, 108, 1),
                                ),
                                filled: true,
                                fillColor: const Color.fromRGBO(44, 44, 44, 1),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(95, 95, 95, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1,
                                    color: Color.fromRGBO(158, 158, 158, 1),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          state.accountCreateMode
                              ? Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom *
                                          .6),
                                  width: MediaQuery.of(context).size.width * .8,
                                  child: TextField(
                                    onTapOutside: (event) => FocusManager
                                        .instance.primaryFocus
                                        ?.unfocus(),
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                          108, 108, 108, 1),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Confirm Password",
                                      hintStyle: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                            108, 108, 108, 1),
                                      ),
                                      filled: true,
                                      fillColor:
                                          const Color.fromRGBO(44, 44, 44, 1),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color: Color.fromRGBO(95, 95, 95, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromRGBO(158, 158, 158, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom *
                                          .4),
                                  child: Text(
                                    "Forgot password?",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                          108, 108, 108, 1),
                                    ),
                                  ),
                                ),
                          state.accountCreateMode
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromRGBO(255, 205, 178, 1),
                                            Color.fromRGBO(255, 180, 162, 1),
                                            Color.fromRGBO(229, 152, 155, 1),
                                            Color.fromRGBO(181, 131, 141, 1),
                                            Color.fromRGBO(109, 104, 117, 1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Create Account",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 60.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromRGBO(255, 205, 178, 1),
                                            Color.fromRGBO(255, 180, 162, 1),
                                            Color.fromRGBO(229, 152, 155, 1),
                                            Color.fromRGBO(181, 131, 141, 1),
                                            Color.fromRGBO(109, 104, 117, 1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Login",
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          state.accountCreateMode
                              ? GestureDetector(
                                  onTap: () =>
                                      context.read<AuthCubit>().swapModes(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      "Have an account? Login",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                            108, 108, 108, 1),
                                      ),
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () =>
                                      context.read<AuthCubit>().swapModes(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      "Create Account",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color.fromRGBO(
                                            108, 108, 108, 1),
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
