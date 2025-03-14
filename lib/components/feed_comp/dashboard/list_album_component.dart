import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';

class ListAlbumComponent extends StatelessWidget {
  final Album album;

  const ListAlbumComponent({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;
    Arguments arguments = Arguments(albumID: album.albumId);

    String displayImageUrl =
        album.images.isNotEmpty && album.phase == AlbumPhases.reveal
            ? album.rankedImages[0].imageReq
            : album.coverReq;

    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed('/album', arguments: arguments).then(
        (value) {
          switch (value) {
            case "showCamera":
              context.read<AppFrameCubit>().changePage(2);
          }
        },
      ),
      child: AspectRatio(
        aspectRatio: 8 / 11,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 8 / 10,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                color: const Color.fromRGBO(19, 19, 19, 1),
                child: CachedNetworkImage(
                  imageUrl: displayImageUrl,
                  httpHeaders: headers,
                  fit: BoxFit.cover,
                  errorListener: (_) {},
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    album.albumName,
                    style: GoogleFonts.josefinSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
