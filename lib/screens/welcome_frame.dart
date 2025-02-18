import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/welcome_cubit.dart';
import 'package:shared_photo/components/new_auth/welcome_comps/profile_upload_slide.dart';

class WelcomeFrame extends StatefulWidget {
  const WelcomeFrame({super.key});

  @override
  State<WelcomeFrame> createState() => _WelcomeFrameState();
}

class _WelcomeFrameState extends State<WelcomeFrame> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(34, 34, 38, 1),
          appBar: AppBar(
            centerTitle: true,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Image.asset("lib/assets/logo.png", height: 40),
            ),
            backgroundColor: Color.fromRGBO(34, 34, 38, 1),
            leading: Icon(
              Icons.abc,
              color: Colors.transparent,
            ),
          ),
          body: BlocProvider(
            create: (context) =>
                WelcomeCubit(user: context.read<AppBloc>().state.user),
            child: ProfileUploadSlide(name: state.user.firstName),
          ),
        );
      },
    );
  }
}
