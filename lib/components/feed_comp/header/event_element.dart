import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/bloc/cubit/app_frame_cubit.dart';
import 'package:shared_photo/components/feed_comp/header/gradient_countdown_timer.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';

class EventElement extends StatelessWidget {
  final Album album;
  const EventElement({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    Arguments arguments = Arguments(albumID: album.albumId);
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed('/album', arguments: arguments).then(
        (value) {
          switch (value) {
            case "showCamera":
              if (context.mounted) {
                context.read<AppFrameCubit>().changePage(2);
              }
          }
        },
      ),
      child: Container(
        margin: EdgeInsets.all(5),
        width: 200,
        decoration: BoxDecoration(
          color: Color.fromRGBO(19, 19, 19, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      album.coverReq,
                      headers: context.read<AppBloc>().state.user.headers,
                      errorListener: (_) {},
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      album.albumName,
                      style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    GradientCountdownTimer(
                      revealDateTime: album.revealDateTime,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
