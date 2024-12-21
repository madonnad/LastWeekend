import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/models/album.dart';

class ProfileEventItem extends StatelessWidget {
  final Album event;
  final Map<String, String> headers;
  const ProfileEventItem({
    super.key,
    required this.event,
    required this.headers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            event.topThreeImages[0].imageReq540,
            headers: headers,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(21, 21, 21, 0),
                  Colors.black87,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 180, 162, .85),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "In Progress",
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  event.albumName,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
                Gap(8),
                Text(
                  event.durationDateFormatter,
                  style: GoogleFonts.montserrat(
                    color: Color.fromRGBO(218, 218, 218, 1),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                  ),
                ),
                Gap(8),
                Row(
                  children: [
                    EventSmallIconText(
                      text: event.guests.length.toString(),
                      icon: Icons.people,
                    ),
                    Gap(30),
                    EventSmallIconText(
                      text: event.images.length.toString(),
                      icon: Icons.image,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventSmallIconText extends StatelessWidget {
  final String text;
  final IconData icon;
  const EventSmallIconText({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 180, 162, .35),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(
            icon,
            color: Color.fromRGBO(255, 180, 162, 1),
            size: 15,
          ),
        ),
        Gap(4),
        Text(
          text,
          style: GoogleFonts.montserrat(
            color: Color.fromRGBO(218, 218, 218, 1),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
