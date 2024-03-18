import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/welcome_cubit.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';
import 'package:shared_photo/components/new_auth/welcome_comps/profile_picture_upload.dart';
import 'package:shared_photo/components/new_auth/welcome_comps/profile_upload_slide.dart';
import 'package:shared_photo/components/new_auth/welcome_comps/welcome_slide.dart';

class WelcomeFrame extends StatefulWidget {
  const WelcomeFrame({super.key});

  @override
  State<WelcomeFrame> createState() => _WelcomeFrameState();
}

class _WelcomeFrameState extends State<WelcomeFrame> {
  double _welcomeOpacity = 0.0;
  double _profPicOpacity = 0.0;

  void _changeWelcomeSlideOpacity() {
    setState(() => _welcomeOpacity = _welcomeOpacity == 0.0 ? 1.0 : 0.0);
  }

  void _changeProPicOpacity() {
    setState(() => _profPicOpacity = _profPicOpacity == 0.0 ? 1.0 : 0.0);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 1, milliseconds: 500),
      () => _changeWelcomeSlideOpacity(),
    );
    Future.delayed(
      const Duration(seconds: 5),
      () => _changeWelcomeSlideOpacity(),
    );
    Future.delayed(
      const Duration(seconds: 8),
      () => _changeProPicOpacity(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            title: const StandardLogo(
              fontSize: 30,
            ),
          ),
          body: BlocProvider(
            create: (context) =>
                WelcomeCubit(user: context.read<AppBloc>().state.user),
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: _welcomeOpacity,
                  duration: const Duration(seconds: 2, milliseconds: 500),
                  child: WelcomeSlide(name: state.user.firstName),
                ),
                AnimatedOpacity(
                  opacity: _profPicOpacity,
                  duration: const Duration(seconds: 2, milliseconds: 500),
                  child: const ProfileUploadSlide(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// context.read<AppBloc>().add(const ChangeNewAccountEvent());
// Navigator.of(context).pop();
