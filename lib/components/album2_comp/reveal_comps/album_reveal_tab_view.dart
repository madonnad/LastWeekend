import 'package:flutter/material.dart';
import 'package:shared_photo/components/album2_comp/reveal_comps/album_reveal_tab_bar.dart';
import 'package:shared_photo/components/album2_comp/reveal_comps/reveal_timeline_page.dart';
import 'package:shared_photo/components/album2_comp/guests_page.dart';
import 'package:shared_photo/components/album2_comp/popular_page.dart';
import 'package:shared_photo/components/album2_comp/timeline_page.dart';
import 'package:shared_photo/models/arguments.dart';

class AlbumRevealTabView extends StatelessWidget {
  final Arguments arguments;
  const AlbumRevealTabView({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 3,
        animationDuration: const Duration(milliseconds: 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: AlbumRevealTabBar(),
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
                    PopularPage(album: arguments.album),
                    GuestsPage(album: arguments.album),
                    RevealTimelinePage(album: arguments.album),
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
