import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/new_app_frame_cubit.dart';
import 'package:shared_photo/components/new_app_frame/camera_nav_element.dart';
import 'package:shared_photo/components/new_app_frame/icon_nav_element.dart';
import 'package:shared_photo/components/new_app_frame/new_bottom_app_bar.dart';

class NewAppFrame extends StatelessWidget {
  const NewAppFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewAppFrameCubit(),
      child: BlocBuilder<NewAppFrameCubit, NewAppFrameState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: state.index == 2 ? true : false,
            backgroundColor: Colors.black,
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: state.pageController,
              children: [
                Center(
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: Container(
                    color: Colors.red,
                  ),
                ),
                Center(
                  child: Container(
                    color: Colors.black,
                  ),
                ),
                Center(
                  child: Container(
                    color: Colors.black,
                  ),
                )
              ],
            ),
            bottomNavigationBar: const NewBottomAppBar(),
          );
        },
      ),
    );
  }
}
/**/
