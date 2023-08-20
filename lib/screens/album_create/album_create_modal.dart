import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/repositories/data_repository.dart';
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
        dataRepository: context.read<DataRepository>(),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: createAlbumController,
          children: [
            AlbumCreateDetail(createAlbumController: createAlbumController),
            AlbumCreateFriends(createAlbumController: createAlbumController),
          ],
        ),
      ),
    );
  }
}
