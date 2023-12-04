import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/new_create_album_comp/create_friend_add_page.dart';
import 'package:shared_photo/repositories/go_repository.dart';
import 'package:shared_photo/screens/album_create/album_create_detail.dart';
import 'package:shared_photo/screens/album_create/album_create_friends.dart';

class AlbumCreateModal extends StatelessWidget {
  const AlbumCreateModal({super.key});

  @override
  Widget build(BuildContext context) {
    PageController createAlbumController = PageController();

    return BlocProvider(
      lazy: false,
      create: (context) => CreateAlbumCubit(
        appBloc: context.read<AppBloc>(),
        profileBloc: context.read<ProfileBloc>(),
        goRepository: context.read<GoRepository>(),
      ),
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: createAlbumController,
        children: [
          AlbumCreateDetail(createAlbumController: createAlbumController),
          CreateFriendAddPage(pageController: createAlbumController),
        ],
      ),
    );
  }
}
