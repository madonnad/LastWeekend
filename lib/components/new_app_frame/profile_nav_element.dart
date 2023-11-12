import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/new_app_frame_cubit.dart';

class ProfileNavElement extends StatelessWidget {
  final int index;

  const ProfileNavElement({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    String? url = context.read<AppBloc>().state.user.avatarUrl;
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;
    return BlocBuilder<NewAppFrameCubit, NewAppFrameState>(
      builder: (context, state) {
        if (state.index == index) {
          return GestureDetector(
            child: Container(
              height: 32,
              width: 32,
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
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
              child: CircleAvatar(
                foregroundImage: url != null ? NetworkImage(url) : null,
                backgroundColor: Colors.black,
                radius: 16,
              ),
            ),
          );
        } else {
          return GestureDetector(
            onTap: () => context.read<NewAppFrameCubit>().changePage(index),
            child: CircleAvatar(
              foregroundImage: url != null ? NetworkImage(url!) : null,
              backgroundColor: Colors.black,
              radius: 15,
            ),
          );
        }
      },
    );
  }
}
