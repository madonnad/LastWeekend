import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/create_album_comp/create_album_info_comp/added_friends_listview.dart';

class AddFriendsInfoList extends StatelessWidget {
  final PageController pageController;

  const AddFriendsInfoList({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
      builder: (context, state) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: GestureDetector(
                onTap: () => pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.linear,
                ),
                child: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white54,
                  size: 35,
                ),
              ),
            ),
            const Expanded(
              child: AddedFriendsListView(),
            ),
          ],
        );
      },
    );
  }
}
