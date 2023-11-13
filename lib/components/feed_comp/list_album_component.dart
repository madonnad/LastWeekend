import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/bloc/profile_bloc.dart';

class ListAlbumComponent extends StatelessWidget {
  final int index;

  const ListAlbumComponent({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    Map<String, String> headers = context.read<AppBloc>().state.user.headers;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return AspectRatio(
          aspectRatio: 8 / 11,
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 8 / 8,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    color: const Color.fromRGBO(19, 19, 19, 1),
                    child: CachedNetworkImage(
                      imageUrl: state.activeAlbums[index].coverReq,
                      httpHeaders: headers,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                child: Expanded(
                  flex: 100,
                  child: FittedBox(
                    child: Text(
                      state.activeAlbums[index].albumName.toUpperCase(),
                      style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
