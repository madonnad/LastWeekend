import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/new_app_frame_cubit.dart';

class IconNavElement extends StatelessWidget {
  final int index;
  final IconData selectedIcon;
  final IconData unselectedIcon;

  const IconNavElement({
    super.key,
    required this.index,
    required this.selectedIcon,
    required this.unselectedIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewAppFrameCubit, NewAppFrameState>(
      builder: (context, state) {
        if (state.index == index) {
          return GestureDetector(
            child: Icon(
              selectedIcon,
              size: 30,
              color: Colors.white,
            ),
          );
        } else if (state.index == 2) {
          return GestureDetector(
            onTap: () => context.read<NewAppFrameCubit>().changePage(index),
            child: Icon(
              unselectedIcon,
              size: 30,
              color: const Color.fromRGBO(159, 159, 159, 1),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => context.read<NewAppFrameCubit>().changePage(index),
            child: Icon(
              unselectedIcon,
              size: 30,
              color: const Color.fromRGBO(44, 44, 44, 1),
            ),
          );
        }
      },
    );
  }
}
