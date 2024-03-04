import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/feed_slideshow_cubit.dart';
import 'package:shared_photo/components/feed_comp/feed/feed_slideshow_inset.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';

class FeedListItem extends StatelessWidget {
  final Album album;
  const FeedListItem({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final double devHeight = MediaQuery.of(context).size.height;
    Arguments arguments =
        Arguments(album: album);

    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 12, right: 12),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Container(
          margin: EdgeInsets.zero,
          height: devHeight * .65,
          child: Card(
            color: const Color.fromRGBO(19, 19, 19, 1),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/album', arguments: arguments),
                        child: Text(
                          album.albumName,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 6.0),
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          Text(
                            "2 days ago",
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    album.fullName,
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white54),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: BlocProvider(
                        create: (context) => FeedSlideshowCubit(album: album),
                        child: const FeedSlideshowInset(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
