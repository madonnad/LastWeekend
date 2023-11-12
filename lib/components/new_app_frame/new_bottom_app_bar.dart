import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/new_app_frame_cubit.dart';
import 'package:shared_photo/components/new_app_frame/camera_nav_element.dart';
import 'package:shared_photo/components/new_app_frame/icon_nav_element.dart';
import 'package:shared_photo/components/new_app_frame/profile_nav_element.dart';

class NewBottomAppBar extends StatelessWidget {
  const NewBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewAppFrameCubit, NewAppFrameState>(
      builder: (context, state) {
        return BottomAppBar(
          height: 85,
          surfaceTintColor: Colors.transparent,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: state.index == 2
                  ? Colors.white
                  : const Color.fromRGBO(19, 19, 19, 1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconNavElement(
                  index: 0,
                  selectedIcon: Icons.search,
                  unselectedIcon: Icons.search_outlined,
                ),
                IconNavElement(
                  index: 1,
                  selectedIcon: Icons.home,
                  unselectedIcon: Icons.home_outlined,
                ),
                CameraNavElement(
                  index: 2,
                ),
                IconNavElement(
                  index: 3,
                  selectedIcon: Icons.favorite,
                  unselectedIcon: Icons.favorite_outline,
                ),
                ProfileNavElement(index: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}
