import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/components/app_comp/animated_logo.dart';
import 'package:shared_photo/components/app_comp/animated_notification.dart';
import 'package:shared_photo/components/app_comp/standard_logo.dart';

class SliverLWAppBar extends StatelessWidget {
  const SliverLWAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return SliverAppBar(
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: state.showNotification
                    ? const AnimatedLogo()
                    : const StandardLogo(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: state.showNotification
                    ? const Padding(
                        padding: EdgeInsets.only(right: 25.0, top: 8),
                        child: AnimatedNotification(),
                      )
                    : null,
              )
            ],
          ),
        );
      },
    );
  }
}
