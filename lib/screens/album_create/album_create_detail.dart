import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_photo/bloc/cubit/create_album_cubit.dart';
import 'package:shared_photo/components/album_create_comp/album_cover_select.dart';
import 'package:shared_photo/components/album_create_comp/album_title_field.dart';
import 'package:shared_photo/components/album_create_comp/date_time_section.dart';
import 'package:shared_photo/components/album_create_comp/modal_header.dart';

class AlbumCreateDetail extends StatelessWidget {
  final PageController createAlbumController;

  const AlbumCreateDetail({Key? key, required this.createAlbumController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: ModalHeader(
                iconFunction: () => Navigator.of(context).pop(),
                title: "",
                icon: const Icon(
                  Icons.close,
                  color: Colors.black45,
                  size: 30,
                ),
              ),
            ),
            const Expanded(
              flex: 2,
              child: Column(
                children: [
                  AlbumTitleField(),
                  AlbumCoverSelect(),
                ],
              ),
            ),
            const Expanded(
              flex: 1,
              child: DateTimeSection(),
            ),
            BlocBuilder<CreateAlbumCubit, CreateAlbumState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.canContinue
                      ? () => createAlbumController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear)
                      : null,
                  child: const Text('Next'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
