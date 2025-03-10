import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/components/feed_comp/feed/feed_slideshow_inset.dart';
import 'package:shared_photo/models/album.dart';
import 'package:shared_photo/models/arguments.dart';

class FeedListItem extends StatelessWidget {
  final Album album;
  const FeedListItem({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    final double devHeight = MediaQuery.of(context).size.height;
    Arguments arguments = Arguments(albumID: album.albumId);

    return GestureDetector(
      onTap: () {
        FirebaseAnalytics.instance.logEvent(
            name: "event_clicked", parameters: {"event_id": album.albumId});
        Navigator.of(context).pushNamed('/album', arguments: arguments);
      },
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: Container(
          color: Colors.transparent,
          height: devHeight * .65,
          child: Card(
            color: const Color.fromRGBO(19, 19, 20, 1),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: InkWell(
                            onTap: () {
                              FirebaseAnalytics.instance.logEvent(
                                  name: "event_clicked",
                                  parameters: {"event_id": album.albumId});
                              Navigator.of(context)
                                  .pushNamed('/album', arguments: arguments);
                            },
                            child: Text(
                              album.albumName,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
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
                            album.timeSince,
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
                      child: FeedSlideshowInset(album: album),
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
