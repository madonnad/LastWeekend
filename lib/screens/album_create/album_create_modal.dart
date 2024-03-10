import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_album_comp/create_album_friend_comp/create_friend_add_page.dart';
import 'package:shared_photo/repositories/data_repository/data_repository.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/screens/album_create/album_create_detail.dart';

class AlbumCreateModal extends StatelessWidget {
  const AlbumCreateModal({super.key});

  @override
  Widget build(BuildContext context) {
    PageController createAlbumController = PageController();

    return BlocProvider(
      lazy: false,
      create: (context) => CreateAlbumCubit(
        userRepository: context.read<UserRepository>(),
        dataRepository: context.read<DataRepository>(),
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
