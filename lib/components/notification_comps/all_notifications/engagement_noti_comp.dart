import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/bloc/app_bloc.dart';
import 'package:shared_photo/models/notification.dart';

class EngagementNotiComp extends StatelessWidget {
  final ConsolidatedNotification notification;
  const EngagementNotiComp({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      height: 69,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(34, 34, 38, 0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
            foregroundImage: CachedNetworkImageProvider(
              notification.notifierURL,
              headers: context.read<AppBloc>().state.user.headers,
              errorListener: (_) {},
            ),
            onForegroundImageError: (_, __) {},
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${notification.fullNotifierName} ",
                        style: GoogleFonts.josefinSans(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: notification.notificationText,
                        style: GoogleFonts.josefinSans(
                          color: Colors.white60,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                notification.timeReceived,
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
    );
  }
}
