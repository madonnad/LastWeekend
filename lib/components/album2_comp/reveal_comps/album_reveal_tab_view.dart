import 'package:flutter/material.dart';
import 'package:shared_photo/components/album2_comp/reveal_comps/album_reveal_tab_bar.dart';
import 'package:shared_photo/components/album2_comp/reveal_comps/reveal_timeline_page.dart';
import 'package:shared_photo/components/album2_comp/guests_page.dart';
import 'package:shared_photo/components/album2_comp/popular_page.dart';

class AlbumRevealTabView extends StatelessWidget {
  const AlbumRevealTabView({super.key});

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
                child: const TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    PopularPage(),
                    GuestsPage(),
                    RevealTimelinePage(),
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
