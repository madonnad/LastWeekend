import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/models/arguments.dart';

class AlbumAppBarTitle extends StatelessWidget {
  final Arguments arguments;
  const AlbumAppBarTitle({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 11,
          child: Text(
            arguments.album.albumName,
            textAlign: TextAlign.center,
            style: GoogleFonts.josefinSans(
              fontWeight: FontWeight.w600,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          child: GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  titleTextStyle: GoogleFonts.josefinSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  title: Center(
                    child: Text(
                      arguments.album.albumName,
                    ),
                  ),
                  children: [
                    SimpleDialogOption(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.white54,
                              ),
                            ),
                            TextSpan(
                              text: "  ",
                              style: GoogleFonts.josefinSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: arguments.album.fullName,
                              style: GoogleFonts.josefinSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SimpleDialogOption(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(
                                Icons.groups,
                                size: 20,
                                color: Colors.white54,
                              ),
                            ),
                            TextSpan(
                              text: "  ",
                              style: GoogleFonts.josefinSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: arguments.album.guests.length.toString(),
                              style: GoogleFonts.josefinSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
