import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/auth_cubit.dart';
import 'package:shared_photo/components/new_auth/account_info/account_page.dart';
import 'package:shared_photo/components/new_auth/personal_info/personal_page.dart';

class SignUpFrame extends StatefulWidget {
  const SignUpFrame({super.key});

  @override
  State<SignUpFrame> createState() => _SignUpFrameState();
}

class _SignUpFrameState extends State<SignUpFrame> {
  int page = 0;
  PageController controller = PageController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passConfirmController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController lastController = TextEditingController();

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
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Color.fromRGBO(19, 19, 20, 1),
              resizeToAvoidBottomInset: true,
              extendBody: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () {
                    if (controller.page == null || controller.page! < 1) {
                      Navigator.of(context).pop();
                    } else {
                      controller.previousPage(
                          duration: Durations.medium1, curve: Curves.linear);
                    }
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(242, 243, 247, 1),
                  ),
                ),
                title: Image.asset("lib/assets/logo.png", height: 40),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        2,
                        (index) {
                          int stop = (page + 1) - index;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: stop >= 1
                                    ? Color.fromRGBO(242, 243, 247, 1)
                                    : Color.fromRGBO(59, 59, 61, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 10,
                              width: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: controller,
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged: (value) => setState(() {
                          page = value;
                        }),
                        children: [
                          AccountPage(
                            controller: controller,
                            emailController: emailController,
                            passController: passController,
                            passConfirmController: passConfirmController,
                          ),
                          PersonalPage(
                            controller: controller,
                            firstController: firstController,
                            lastController: lastController,
                            emailController: emailController,
                            passController: passController,
                          ),
                        ],
                      ),
                    ),
                  ],
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
