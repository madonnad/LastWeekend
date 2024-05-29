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
      onTap: () =>
          Navigator.of(context).pushNamed('/album', arguments: arguments),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        height: 75,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(19, 19, 19, 1),
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
                    image: NetworkImage(
                      notification.imageURL,
                      headers: context.read<AppBloc>().state.user.headers,
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
                      style: GoogleFonts.montserrat(
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
