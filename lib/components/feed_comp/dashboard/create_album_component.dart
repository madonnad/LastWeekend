import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/repositories/user_repository.dart';
import 'package:shared_photo/screens/album_create/album_create_modal.dart';

class CreateAlbumComponent extends StatelessWidget {
  const CreateAlbumComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        showModalBottomSheet(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          isScrollControlled: true,
          context: context,
          builder: (ctx) => RepositoryProvider.value(
            value: context.read<UserRepository>(),
            child: const AlbumCreateModal(),
          ),
        );
      },
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 2 / 5,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                color: const Color.fromRGBO(19, 19, 19, 1),
                child: const Center(
                  child: Icon(
                    Icons.add_circle_outline,
                    size: 35,
                    color: Color.fromRGBO(213, 213, 213, 1),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              "",
            ),
          ),
        ],
      ),
    );
  }
}
