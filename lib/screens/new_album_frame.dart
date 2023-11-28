import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_photo/bloc/cubit/new_album_frame_cubit.dart';
import 'package:shared_photo/components/new_album_comp/popular_comp/popular_page.dart';
import 'package:shared_photo/models/arguments.dart';

class NewAlbumFrame extends StatelessWidget {
  final Arguments arguments;
  final List<String> filterList = ["Popular", "Guests", "Timeline"];

  NewAlbumFrame({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewAlbumFrameCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
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
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    arguments.album.albumName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.josefinSans(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
                        title: const Center(
                          child: Text(
                            "Album Information",
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
                                    text: arguments.album.guests.length
                                        .toString(),
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
          ),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 7) {
              Navigator.of(context).pop();
            }
          },
          child: DefaultTabController(
            length: 3,
            animationDuration: const Duration(milliseconds: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ButtonsTabBar(
                    duration: 1,
                    buttonMargin:
                        const EdgeInsets.only(top: 9, bottom: 9, right: 16),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    radius: 20,
                    unselectedDecoration: const BoxDecoration(
                      color: Color.fromRGBO(44, 44, 44, 1),
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 205, 178, 1),
                          Color.fromRGBO(255, 180, 162, 1),
                          Color.fromRGBO(229, 152, 155, 1),
                          Color.fromRGBO(181, 131, 141, 1),
                          Color.fromRGBO(109, 104, 117, 1),
                        ],
                      ),
                    ),
                    unselectedLabelStyle: const TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    labelStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    tabs: const [
                      Tab(
                        text: "POPULAR",
                      ),
                      Tab(
                        text: "GUESTS",
                      ),
                      Tab(
                        text: "TIMELINE",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 7) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        PopularPage(
                          album: arguments.album,
                        ),
                        Container(
                          width: 600,
                          height: 800,
                          color: Colors.green,
                          child: const Center(
                            child: Icon(
                              Icons.directions_car,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            width: 600,
                            height: 800,
                            color: Colors.blue,
                            child: const Center(
                              child: Icon(
                                Icons.directions_car,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
