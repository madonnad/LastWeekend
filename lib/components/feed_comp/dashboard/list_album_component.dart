import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';
import 'package:shared_photo/models/album.dart';

class ListAlbumComponent extends StatelessWidget {
  final int index;
  final Album album;

  const ListAlbumComponent(
      {super.key, required this.index, required this.album});

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;
    return AspectRatio(
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
                imageUrl: album.coverReq,
                httpHeaders: headers,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  album.albumName.toUpperCase(),
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
    );
  }
}
