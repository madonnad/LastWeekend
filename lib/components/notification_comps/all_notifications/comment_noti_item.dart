import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/arguments.dart';
import 'package:shared_photo/models/notification.dart';

class CommentNotiItem extends StatelessWidget {
  final CommentNotification notification;
  const CommentNotiItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    Arguments arguments = Arguments(
      albumID: notification.albumID,
      imageID: notification.notificationMediaID,
    );
    return GestureDetector(
      onTap: () {
        FirebaseAnalytics.instance.logEvent(
            name: "event_clicked",
            parameters: {"event_id": notification.albumID});
        Navigator.of(context).pushNamed('/album', arguments: arguments);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        height: 75,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(34, 34, 38, 0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 60 / 65,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(44, 44, 44, 1),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      notification.imageURL,
                      headers: context.read<AppBloc>().state.user.headers,
                      errorListener: (_) {},
                    ),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${notification.fullName} commented:",
                    style: GoogleFonts.josefinSans(
                      color: Colors.white60,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      notification.comment,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  notification.shortTime,
                  style: GoogleFonts.josefinSans(
                    color: Colors.white54,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
